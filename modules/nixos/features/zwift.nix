{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  feature_name = "zwift";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in {
  imports = [inputs.zwift.nixosModules.zwift];

  config = {
    networking = lib.mkIf enabled {
      firewall = {
        allowedUDPPorts = [
          3022
          3024
        ];
        allowedTCPPorts = [21587 21588];
      };
    };
    environment.systemPackages = with pkgs;
      lib.optionals enabled [
        libsecret
      ];

    programs.zwift = {
      containerTool = "podman";
      dontPull = true;
      enable = enabled;
      image = "docker.io/netbrain/zwift";
      networking = "host";
      wineExperimentalWayland = true;
      zwiftActivityDir = "/var/lib/zwift/activities";
      zwiftLogDir = "/var/lib/zwift/logs";
      zwiftScreenshotsDir = "/var/lib/zwift/screenshots";
      zwiftUsername = "sebas@zaffarano.com.ar";
      zwiftWorkoutDir = "/var/lib/zwift/workouts";
    };

    nixos.custom.features.register = feature_name;
  };
}
