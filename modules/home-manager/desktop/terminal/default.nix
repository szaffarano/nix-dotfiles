{ config, lib, ... }:
let
  cfg = config.desktop.terminal;
in
with lib;
{
  imports = [ ./wezterm.nix ];

  options.desktop.terminal.enable = mkEnableOption "desktop terminal";

  config = mkIf cfg.enable { desktop.terminal.wezterm.enable = true; };
}
