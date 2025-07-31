{
  lib,
  config,
  pkgs,
  ...
}: let
  is_installed = name: (lib.lists.any (e: e == name) (lib.attrNames config.programs.mise.globalConfig.tools));

  node_installed = is_installed "node";
in {
  config = {
    programs.mise = {
      enableZshIntegration = config.programs.zsh.enable;
      enableFishIntegration = config.programs.fish.enable;

      globalConfig = lib.mkDefault {
        settings = {
          all_compile = false;
          experimental = true;
          # https://github.com/jdx/mise/discussions/4345
          idiomatic_version_file_enable_tools = ["python" "node"];
        };
        settings.python = {
          compile = false;
        };
        settings.node = {
          compile = false;
          gpg_verify = false;
        };
        tools = {
          claude-code = "latest";
          java = "temurin-21.0.8+9.0.LTS";
          node = "lts";
          opencode = "latest";
          python = "latest";
          ruff = "latest";
          terraform = "latest";
          tflint = "latest";
        };
      };
    };

    home = {
      packages = with pkgs; [usage];

      file = lib.mkIf node_installed {
        ".local/bin/node-latest" = {
          text = ''
            #!/usr/bin/env bash

            ${lib.getExe pkgs.mise} exec node@latest -- node "$@"
          '';
          executable = true;
        };
        ".default-npm-packages".text = lib.mkDefault ''
          bash-language-server
          yarn
        '';
      };
    };
  };
}
