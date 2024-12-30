{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.wayland.wofi;
in
  with lib; {
    options.desktop.wayland.wofi.enable = mkEnableOption "wofi";

    config = mkIf cfg.enable {
      home.packages = [pkgs.inputs.wofi-tools.wofi-power-menu];

      programs.wofi = {
        enable = true;
        settings = {
          image_size = 48;
          columns = 3;
          allow_images = true;
          insensitive = true;
          run-always_parse_args = true;
          run-cache_file = "/dev/null";
          run-exec_search = true;
        };
      };
    };
  }
