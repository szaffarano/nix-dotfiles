{
  lib,
  stdenvNoCC,
  buildGoModule,
  bun,
  fetchFromGitHub,
  fetchurl,
  nix-update-script,
  testers,
  writableTmpDirAsHomeHook,
}: let
  opencode-node-modules-hash = {
    "x86_64-linux" = "sha256-R51kvHgoCbSg+9Iice8+scAMKQZHR2HWJTJIUm5u1XA=";
  };
  bun-target = {
    "x86_64-linux" = "bun-linux-x64";
  };
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    version = "0.3.79";
    pname = "opencode";
    src = fetchFromGitHub {
      owner = "sst";
      repo = "opencode";
      tag = "v${finalAttrs.version}";
      hash = "sha256-Vmv9nAr9VQbNuNWDbXxVtt6xbbSo38VEz+klcDI6aLs=";
    };

    tui = buildGoModule {
      pname = "opencode-tui";
      inherit (finalAttrs) version;
      src = "${finalAttrs.src}/packages/tui";

      vendorHash = "sha256-g2IhNOIKuBf4G4PioXhFvKIWds9ZiYfiG9vnyXCaz6o=";

      subPackages = ["cmd/opencode"];

      env.CGO_ENABLED = 0;

      ldflags = [
        "-s"
        "-X=main.Version=${finalAttrs.version}"
      ];

      installPhase = ''
        runHook preInstall

        install -Dm755 $GOPATH/bin/opencode $out/bin/tui

        runHook postInstall
      '';
    };

    node_modules = stdenvNoCC.mkDerivation {
      pname = "opencode-node_modules";
      inherit (finalAttrs) version src;

      impureEnvVars =
        lib.fetchers.proxyImpureEnvVars
        ++ [
          "GIT_PROXY_COMMAND"
          "SOCKS_SERVER"
        ];

      nativeBuildInputs = [
        bun
        writableTmpDirAsHomeHook
      ];

      dontConfigure = true;

      buildPhase = ''
        runHook preBuild

         export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

         bun install \
           --filter=opencode \
           --force \
           --frozen-lockfile \
           --no-progress

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out/node_modules
        cp -R ./node_modules $out

        runHook postInstall
      '';

      # Required else we get errors that our fixed-output derivation references store paths
      dontFixup = true;

      outputHash = opencode-node-modules-hash.${stdenvNoCC.hostPlatform.system};
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      patches = [./fix-import.patch];
    };

    models-dev-data = fetchurl {
      url = "https://models.dev/api.json";
      sha256 = "sha256-igxQOC+Hz2FnXIW/S4Px9WhRuBhcIQIHO+7U8jHU1TQ=";
    };

    nativeBuildInputs = [bun];

    patches = [./fix-models-macro.patch];

    configurePhase = ''
      runHook preConfigure

      cp -R ${finalAttrs.node_modules}/node_modules .

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      export MODELS_JSON="$(cat ${finalAttrs.models-dev-data})"
      bun build \
        --define OPENCODE_VERSION="'${finalAttrs.version}'" \
        --compile \
        --minify \
        --target=${bun-target.${stdenvNoCC.hostPlatform.system}} \
        --outfile=opencode \
        ./packages/opencode/src/index.ts \
        ${finalAttrs.tui}/bin/tui

      runHook postBuild
    '';

    dontStrip = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      install -Dm755 opencode $out/bin/opencode

      runHook postInstall
    '';

    passthru = {
      tests.version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "HOME=$(mktemp -d) opencode --version";
        inherit (finalAttrs) version;
      };
      updateScript = nix-update-script {
        extraArgs = [
          "--subpackage"
          "tui"
          "--subpackage"
          "node_modules"
          "--subpackage"
          "models-dev-data"
        ];
      };
    };

    meta = {
      description = "AI coding agent built for the terminal";
      longDescription = ''
        OpenCode is a terminal-based agent that can build anything.
        It combines a TypeScript/JavaScript core with a Go-based TUI
        to provide an interactive AI coding experience.
      '';
      homepage = "https://github.com/sst/opencode";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [
        zestsystem
        delafthi
      ];
      mainProgram = "opencode";
    };
  })
