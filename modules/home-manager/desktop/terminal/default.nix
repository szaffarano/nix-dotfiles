{
  config,
  lib,
  ...
}: let
  cfg = config.desktop.terminal;
in
  with lib; {
    imports = [
      ./alacritty.nix
      ./foot.nix
      ./wezterm.nix
    ];

    options.desktop.terminal.enable = mkEnableOption "desktop terminal";

    config = mkIf cfg.enable {
      desktop.terminal = {
        foot.enable = lib.mkDefault true;
        wezterm.enable = lib.mkDefault false;
        alacritty.enable = lib.mkDefault false;
      };
    };
  }
