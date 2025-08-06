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
        settings = {
          theme = "base16";
          client_id_command = {
            command = "get-keepass-entry";
            args = [
              "spotify-player"
              "https://developer.spotify.com"
            ];
          };
        };
        themes = with config.colorScheme.palette; [
          {
            name = "base16";
            palette = {
              background = "#${base00}";
              foreground = "#${base05}";
              black = "#${base00}";
              blue = "#${base0D}";
              cyan = "#${base0C}";
              green = "#${base0B}";
              magenta = "#${base0E}";
              red = "#${base08}";
              white = "#${base05}";
              yellow = "#${base0A}";
              bright_black = "#${base03}";
              bright_blue = "#${base0D}";
              bright_cyan = "#${base0C}";
              bright_green = "#${base0B}";
              bright_magenta = "#${base0E}";
              bright_red = "#${base08}";
              bright_white = "#${base07}";
              bright_yellow = "#${base0A}";
            };
            component_style = {
              selection = {
                bg = "#${base02}";
                modifiers = ["Bold"];
              };
              block_title = {fg = "Magenta";};
              playback_track = {
                fg = "Cyan";
                modifiers = ["Bold"];
              };
              playback_album = {fg = "Yellow";};
              playback_metadata = {fg = "Blue";};
              playback_progress_bar = {
                bg = "#${base02}";
                fg = "Green";
              };
              current_playing = {
                fg = "Green";
                modifiers = ["Bold"];
              };
              page_desc = {
                fg = "Cyan";
                modifiers = ["Bold"];
              };
              table_header = {fg = "Blue";};
              border = {};
              playback_status = {
                fg = "Cyan";
                modifiers = ["Bold"];
              };
              playback_artists = {
                fg = "Cyan";
                modifiers = ["Bold"];
              };
              playlist_desc = {fg = "#${base04}";};
            };
          }
        ];
      };
      programs.ncspot = {
        enable = true;
        settings = {
          use_nerdfont = true;
          notify = true;

          theme = with config.colorScheme.palette; {
            background = "#${base00}";
            primary = "#${base05}";
            secondary = "#${base03}";
            title = "#${base0D}";
            playing = "#${base0B}";
            playing_bg = "#${base00}";
            highlight = "#${base00}";
            highlight_bg = "#${base04}";
            error = "#${base00}";
            error_bg = "#${base08}";
            statusbar = "#${base00}";
            statusbar_progress = "#${base0C}";
            statusbar_bg = "#${base0D}";
            cmdline = "#${base05}";
            cmdline_bg = "#${base01}";
          };
        };
      };
    };
  }
