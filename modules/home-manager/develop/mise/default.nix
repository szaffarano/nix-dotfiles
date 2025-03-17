{
  lib,
  config,
  pkgs,
  ...
}: let
  is_installed = name: (lib.lists.any (e: e == name) (lib.attrNames config.programs.mise.globalConfig.tools));

  terraform_installed = is_installed "terraform";
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
          idiomatic_version_file_disable_tools = lib.mkIf terraform_installed ["terraform"];
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
        };
      };
    };

    home = {
      packages = with pkgs; [usage];

      file = lib.mkIf node_installed {
        ".default-npm-packages".text = lib.mkDefault ''
          bash-language-server
          yarn
        '';
      };
    };
  };
}
