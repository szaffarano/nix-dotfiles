{ pkgs, ... }:

let
  rev = "cadc325194f7dbbff6ef29caa589c5f976d4ed2b";
  hash = "sha256-BQfbNV3fPdayodqIyo2lHnekbpFikSS7oz5Nkh60xO4=";
  alsa-ucm-conf-chromebook =
    with pkgs;
    alsa-ucm-conf.overrideAttrs {
      wttsrc = fetchFromGitHub {
        inherit rev hash;
        owner = "WeirdTreeThing";
        repo = "chromebook-ucm-conf";
      };
      postInstall = ''
        echo "${rev}" > $out/chromebook.patched

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
