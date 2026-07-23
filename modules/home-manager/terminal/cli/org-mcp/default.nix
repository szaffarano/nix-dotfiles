{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.terminal.cli.org-mcp;
  fmt = pkgs.formats.toml {};
in
  with lib; {
    options.terminal.cli.org-mcp = {
      enable = mkEnableOption "org-mcp";

      settings = mkOption {
        inherit (fmt) type;
        description = "org-mcp config.toml contents";
        default = {
          org = {
            org_directory = "~/Documents/org.new/";
            org_default_notes_file = "notes.org";
            org_agenda_files = [
              "agenda.org"
              "~/Documents/org.new/**/*.org"
            ];
            org_agenda_text_search_extra_files = [];
            org_todo_keywords = ["TODO" "PROGRESS" "|" "DONE" "REJECTED"];
            org_auto_created_property = true;
          };
          logging = {
            level = "info";
            file = "~/.local/share/org-mcp-server/logs/server.log";
          };
          cli.default_format = "plain";
        };
      };
    };

    config = mkIf cfg.enable {
      home.packages = [pkgs.inputs.org-mcp-server.default];

      xdg.configFile."org-mcp/config.toml".source =
        fmt.generate "config.toml" cfg.settings;
    };
  }
