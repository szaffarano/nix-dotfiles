{
  lib,
  pkgs,
  stdenv,
}: let
  rtpPath = "share/tmux-plugins";

  addRtp = path: rtpFilePath: attrs: derivation:
    derivation
    // {
      rtp = "${derivation}/${path}/${rtpFilePath}";
    }
    // {
      overrideAttrs = f:
        mkTmuxPlugin (attrs
          // (
            if lib.isFunction f
            then f attrs
            else f
          ));
    };
  mkTmuxPlugin = a @ {
    pluginName,
    rtpFilePath ? (builtins.replaceStrings ["-"] ["_"] pluginName) + ".tmux",
    namePrefix ? "tmuxplugin-",
    unpackPhase ? "",
    configurePhase ? ":",
    buildPhase ? ":",
    addonInfo ? null,
    preInstall ? "",
    postInstall ? "",
    path ? lib.getName pluginName,
    ...
  }:
    if lib.hasAttr "dependencies" a
    then throw "dependencies attribute is obselete. see NixOS/nixpkgs#118034" # added 2021-04-01
    else
      addRtp "${rtpPath}/${path}" rtpFilePath a (
        stdenv.mkDerivation (
          a
          // {
            pname = namePrefix + pluginName;

            inherit
              pluginName
              unpackPhase
              configurePhase
              buildPhase
              addonInfo
              preInstall
              postInstall
              ;

            installPhase = ''
              runHook preInstall

              target=$out/${rtpPath}/${path}
              mkdir -p $out/${rtpPath}
              cp -r . $target
              if [ -n "$addonInfo" ]; then
                echo "$addonInfo" > $target/addon-info.json
              fi

              runHook postInstall
            '';
          }
        )
      );
in
  mkTmuxPlugin rec {
    pluginName = "tmux-toggle-popup";
    rtpFilePath = "toggle-popup.tmux";
    version = "0.4.2";
    src = pkgs.fetchFromGitHub {
      owner = "loichyan";
      repo = "tmux-toggle-popup";
      tag = "v${version}";
      hash = "sha256-dlCUK+yrBkY0DnKoj/s9dJ6yITBMfWMgw3wnwzuxim4=";
    };
  }
