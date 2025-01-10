{pkgs, ...}: let
  alsa-ucm-conf-chromebook = with pkgs;
    alsa-ucm-conf.overrideAttrs {
      wttsrc = fetchFromGitHub {
        rev = "00b399ed00930bfe544a34358547ab20652d71e3";
        hash = "sha256-lRrgZDb3nnZ6/UcIsfjqAAbbSMOkP3lBGoGzZci+c1k=";
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
