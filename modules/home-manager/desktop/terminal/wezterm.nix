{ config, lib, ... }:
let
  inherit (config.fontProfiles) monospace;
  inherit (config) scheme;
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
          font = wezterm.font("${monospace.name}"),
          font_size = ${builtins.toString (monospace.sizeAsInt * 0.9)},
          color_scheme = "${scheme.slug}",

          window_padding = {
            left = 5,
            right = 10,
            top = 5,
            bottom = 5,
          },

          -- TODO: remove once https://github.com/wez/wezterm/issues/5990 is fixed
          front_end = "WebGpu",

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
