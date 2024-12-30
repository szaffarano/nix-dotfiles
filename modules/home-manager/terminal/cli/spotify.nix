{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.terminal.cli.spotify;
in
  with lib; {
    options.terminal.cli.spotify = {
      enable = mkEnableOption "spotify";
      exe = mkOption {
        type = types.str;
        description = "Path to the Spotify client binary (either ncspot or spotify_player)";
        readOnly = true;
      };
    };

    config = mkIf cfg.enable {
      home.packages = [
        pkgs.spotify-player
        pkgs.librespot
      ];
      terminal.cli.spotify.exe = lib.getExe pkgs.spotify-player;
      programs.spotify-player = {
        enable = true;
      };
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
