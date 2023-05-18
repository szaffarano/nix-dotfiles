_:
{ config, lib, pkgs, theme, ... }: {
  options.wezterm.enable = lib.mkEnableOption "wezterm";

  config = lib.mkIf config.wezterm.enable {
    programs.wezterm = {
      enable = true;
      extraConfig = ''
        local act = wezterm.action
        local wezterm = require 'wezterm'
        return {
          font = wezterm.font("${theme.wezterm.fonts.name}"),
          font_size = ${builtins.toString theme.wezterm.fonts.size},
          color_scheme = "${theme.wezterm.theme}",
          hide_tab_bar_if_only_one_tab = true,
          window_padding = {
            left = 5,
            right = 10,
            top = 5,
            bottom = 5,
          },
          keys = {
            { key = '/', mods = 'CTRL', action = act.QuickSelect },
          },
        }
      '';
    };
  };
}
