_:
{ config, lib, pkgs, theme, ... }: {
  options.kitty.enable = lib.mkEnableOption "kitty";

  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "Iosevka Extended";
        size = 16;
      };
      settings = {
        copy_on_select = true;
        enable_audio_bell = false;
        adjust_line_height = "105%";
      };
      theme = "Catppuccin-Frappe";
    };

    home.sessionVariables = { TERMINAL = "kitty"; };
  };
}
