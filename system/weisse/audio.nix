{ pkgs, ... }:

let
  alsa-ucm-conf-chromebook =
    with pkgs;
    alsa-ucm-conf.overrideAttrs {
      wttsrc = fetchFromGitHub {
        owner = "WeirdTreeThing";
        repo = "chromebook-ucm-conf";
        rev = "b6ce2a7";
        hash = "sha256-QRUKHd3RQmg1tnZU8KCW0AmDtfw/daOJ/H3XU5qWTCc=";
      };
      postInstall = ''
        echo "v0.4.1" > $out/chromebook.patched

        # Asus Chromebook CX1400 (GALTIC)
        #   ❯ aplay -l
        #   card 0: sofrt5682 [sof-rt5682], device 0: Headphones (*) []
        #   ....
        cp -R $wttsrc/sof-rt5682 $out/share/alsa/ucm2/conf.d
        cp -R $wttsrc/common/* $out/share/alsa/ucm2/common
        cp -R $wttsrc/codecs/* $out/share/alsa/ucm2/codecs
        cp -R $wttsrc/platforms/* $out/share/alsa/ucm2/platforms
      '';
    };
in
{
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

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  services.pipewire.wireplumber.configPackages = [
    (pkgs.writeTextDir "share/wireplumber/main.lua.d/51-increase-headroom.lua" ''
      rule = {
        matches = {
          {
            { "node.name", "matches", "alsa_output.*" },
          },
        },
        apply_properties = {
          ["api.alsa.headroom"] = 4096,
        },
      }

      table.insert(alsa_monitor.rules,rule)
    '')
  ];
}
