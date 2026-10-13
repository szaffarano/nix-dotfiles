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
    programs = {
      fish = lib.mkIf config.programs.fish.enable {
        interactiveShellInit = ''
          if not set -q IN_NIX_SHELL; and not set -q NIX_BUILD_TOP
              ${pkgs.mise}/bin/mise activate fish | source
          end

          function cleanup_mise_hooks --on-event fish_prompt
              if set -q IN_NIX_SHELL; or set -q NIX_BUILD_TOP
                  if functions -q _mise_hook
                      functions -e _mise_hook
                  end
              end
          end
        '';
      };

      zsh = lib.mkIf config.programs.zsh.enable {
        initExtra = ''
          if [ -z "$IN_NIX_SHELL" ] && [ -z "$NIX_BUILD_TOP" ]; then
              eval "$(${pkgs.mise}/bin/mise activate zsh)"
          else
              if type add-zsh-hook >/dev/null 2>&1; then
                  add-zsh-hook -d precmd _mise_hook 2>/dev/null
              fi
          fi
        '';
      };

      mise = {
        enableZshIntegration = false;
        enableFishIntegration = false;

        globalConfig = lib.mkDefault {
          settings = {
            all_compile = false;
            experimental = true;
            idiomatic_version_file_enable_tools = ["python" "node"]; # https://github.com/jdx/mise/discussions/4345
          };
          settings.python = {
            compile = false;
          };
          settings.node = {
            compile = false;
            gpg_verify = false;
          };
          tools = {
            bun = "latest";
            gcloud = "latest";
            java = "temurin-25.0.0+36.0.LTS";
            node = "lts";
            python = "latest";
            ruff = "latest";
            terraform = "latest";
            tflint = "latest";
          };
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
          context-mode
          @devcontainers/cli
          @earendil-works/pi-coding-agent
          @github/copilot
          @github/copilot-language-server
          yarn
        '';
        ".default-python-packages".text = lib.mkDefault ''
          poetry
          pip
        '';
      };
    };
  };
}
