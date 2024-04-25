{ config
, lib
, theme
, ...
}:
let
  cfg = config.desktop.terminal.wezterm;
in
with lib;
{

  options.desktop.terminal.wezterm.enable = mkEnableOption "wezterm";

  config = mkIf cfg.enable {
    home = {
      sessionVariables = {
        TERMINAL = "wezterm";
      };
    };

    programs.wezterm = {
      enable = true;

      extraConfig = ''
        local act = wezterm.action
        local wezterm = require 'wezterm'

        return {
          enable_wayland = true,
          font = wezterm.font("${theme.wezterm.fonts.name}"),
          font_size = ${builtins.toString theme.wezterm.fonts.size},
          color_scheme = "${theme.wezterm.theme}",

          window_padding = {
            left = 5,
            right = 10,
            top = 5,
            bottom = 5,
          },

          keys = {
            { key = '/', mods = 'CTRL', action = act.QuickSelect },
          },

          hide_tab_bar_if_only_one_tab = true,
          window_close_confirmation = "NeverPrompt",

          set_environment_variables = {
            TERM = 'wezterm',
          },
        }
      '';
    };
  };
}
