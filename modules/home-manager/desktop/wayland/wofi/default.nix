{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.desktop.wayland.wofi;
in
with lib;
{
  options.desktop.wayland.wofi.enable = mkEnableOption "wofi";

  config = mkIf cfg.enable {

    home.packages = [ inputs.wofi-power-menu.packages.${pkgs.hostPlatform.system}.wofi-power-menu ];

    programs.wofi = {
      enable = true;
      package = pkgs.wofi.overrideAttrs (oa: {
        patches = (oa.patches or [ ]) ++ [
          # Fix for https://todo.sr.ht/~scoopta/wofi/174
          ./wofi-run-shell.patch
        ];
      });
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
