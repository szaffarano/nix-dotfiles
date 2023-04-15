_:
{ config, lib, pkgs, theme, ... }: {
  options.kitty.enable = lib.mkEnableOption "kitty";

  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "FiraCode Nerd Font";
        size = 13;
      };
      settings = {
        adjust_line_height = "105%";
        copy_on_select = true;
        enable_audio_bell = false;
        hide_window_decorations = "titlebar-only";
      };
      theme = "Catppuccin-Frappe";
    };

    home.sessionVariables = { TERMINAL = "kitty"; };
  };
}
