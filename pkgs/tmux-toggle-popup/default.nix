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
  mkTmuxPlugin {
    pluginName = "tmux-toggle-popup";
    rtpFilePath = "toggle-popup.tmux";
    version = "0.4.2-dev";
    src = pkgs.fetchFromGitHub {
      owner = "loichyan";
      repo = "tmux-toggle-popup";
      rev = "91ba1e9a5caab2af80dac8e572f8543aeb63084d";
      hash = "sha256-py9c/Sa1W/jQvF2kJrw54ZEL3nd6KeF6k9sOQZt1eJ0=";
    };
  }
