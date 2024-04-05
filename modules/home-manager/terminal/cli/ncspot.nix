{ config, lib, ... }:
let
  cfg = config.terminal.cli.ncspot;
in
with lib;
{
  options.terminal.cli.ncspot.enable = mkEnableOption "ncspot";

  config = mkIf cfg.enable {
    programs.ncspot = {
      enable = true;
      settings = {
        use_nerdfont = true;
        notify = true;

        # TODO: integrate with global theme
        theme = {
          background = "black";
          primary = "light white";
          secondary = "light black";
          title = "green";
          playing = "green";
          playing_selected = "light green";
          playing_bg = "black";
          highlight = "light white";
          highlight_bg = "#484848";
          error = "light white";
          error_bg = "red";
          statusbar = "black";
          statusbar_progress = "green";
          statusbar_bg = "green";
          cmdline = "light white";
          cmdline_bg = "black";
          search_match = "light red";
        };
      };
    };
  };
}
