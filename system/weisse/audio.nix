{ pkgs, ... }:

let
  alsa-ucm-conf-chromebook =
    with pkgs;
    alsa-ucm-conf.overrideAttrs {
      wttsrc = fetchFromGitHub {
        owner = "WeirdTreeThing";
        repo = "chromebook-ucm-conf";
        rev = "b6ce2a76f6360b87bfe593ff14dffc125fd9c671";
        hash = "sha256-QRUKHd3RQmg1tnZU8KCW0AmDtfw/daOJ/H3XU5qWTCc=";
      };
      postInstall = ''
        touch $out/chromebook.patched

        cp -r $wttsrc/jsl/* $out/share/alsa/ucm2/conf.d

        cp -r $wttsrc/common $out/share/alsa/ucm2
        cp -r $wttsrc/codecs $out/share/alsa/ucm2
        cp -r $wttsrc/platforms $out/share/alsa/ucm2

        cp -r $wttsrc/sof-rt5682 $out/share/alsa/ucm2/conf.d
        cp -r $wttsrc/sof-cs42l42 $out/share/alsa/ucm2/conf.d
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
      maliit-keyboard
      sof-firmware
    ];
    sessionVariables.ALSA_CONFIG_UCM2 = "${alsa-ucm-conf-chromebook}/share/alsa/ucm2";
  };

  system.replaceRuntimeDependencies = with pkgs; [
    ({
      original = alsa-ucm-conf;
      replacement = alsa-ucm-conf-chromebook;
    })
  ];

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
