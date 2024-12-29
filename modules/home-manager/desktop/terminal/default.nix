{
  config,
  lib,
  ...
}: let
  cfg = config.desktop.terminal;
in
  with lib; {
    imports = [
      ./foot.nix
      ./wezterm.nix
    ];

    options.desktop.terminal.enable = mkEnableOption "desktop terminal";

    config = mkIf cfg.enable {
      desktop.terminal.foot.enable = true;
      desktop.terminal.wezterm.enable = false;
    };
  }
