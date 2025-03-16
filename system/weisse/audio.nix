{pkgs, ...}: let
  alsa-ucm-conf-chromebook = with pkgs;
    alsa-ucm-conf.overrideAttrs {
      wttsrc = fetchFromGitHub {
        rev = "cd4a951ea8b5a257671db32bca5b0ca25ad726d8";
        hash = "sha256-KRmeFR2EhXAiPk+WG2P7xklrOSIoCzzAD5x1OleNLlc=";
        owner = "WeirdTreeThing";
        repo = "alsa-ucm-conf-cros";
      };
      postInstall = ''
        cp -R $wttsrc/ucm2/* $out/share/alsa/ucm2/
        cp -R $wttsrc/overrides/* $out/share/alsa/ucm2/conf.d/
      '';
    };
in {
  boot = {
    extraModprobeConfig = ''
      options snd-intel-dspcfg dsp_driver=3
    '';
  };

  environment = {
    systemPackages = with pkgs; [
      alsa-ucm-conf
      sof-firmware
    ];
    sessionVariables = {
      ALSA_CONFIG_UCM2 = "${alsa-ucm-conf-chromebook}/share/alsa/ucm2";
    };
  };

  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    pipewire.wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-increase-headroom.conf" ''
        monitor.alsa.rules = [
          {
            matches = [
              {
                node.name = "~alsa_output.*"
              }
            ]
            actions = {
              update-props = {
                api.alsa.headroom = 4096
              }
            }
          }
        ]
      '')
    ];
  };
}
