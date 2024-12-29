{
  lib,
  config,
  ...
}: let
  is_installed = name: (lib.lists.any (e: e == name) (lib.attrNames config.programs.mise.globalConfig.tools));

  terraform_installed = is_installed "terraform";
  node_installed = is_installed "node";
in {
  config = {
    programs.mise = {
      enableZshIntegration = true;
      enableBashIntegration = false;
      enableFishIntegration = false;

      globalConfig = lib.mkDefault {
        settings = {
          all_compile = false;
          experimental = true;
        };
        settings.python = {
          compile = false;
        };
        settings.node = {
          compile = false;
          gpg_verify = false;
        };
        tools = {
          java = "temurin-21.0.5+11.0.LTS";
          node = "lts";
          python = "latest";
          ruff = "latest";
          terraform = "latest";
          tflint = "latest";
          usage = "latest";
        };
      };
    };

    home.sessionVariables = lib.mkIf terraform_installed {
      MISE_LEGACY_VERSION_FILE_DISABLE_TOOLS = "terraform";
    };

    home.file = lib.mkIf node_installed {
      ".default-npm-packages".text = lib.mkDefault ''
        bash-language-server
        yarn
      '';
    };
  };
}
