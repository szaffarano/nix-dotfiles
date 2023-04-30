_:
{ config, lib, pkgs, ... }:
let
  c = config.homeDirectory;
in
{
  options.development.enable = lib.mkEnableOption "development";
  options.development.intellij-idea-pkg = lib.mkOption {
    default = pkgs.jetbrains.idea-community;
    type = lib.types.package;
    description = "IntelliJ IDEA package to use";
  };
  options.development.datagrip.enable = lib.mkEnableOption {
    default = false;
    description = "Enable DataGrip";
  };

  config = lib.mkIf config.development.enable {
    programs.java.enable = true;
    programs.vscode = {
      enable = true;
      enableExtensionUpdateCheck = true;
    };
    home = {
      packages = with pkgs; [
        config.development.intellij-idea-pkg

        poetry
        pipx

        asdf-vm

        nixfmt
        rustup

        hyperfine

        pre-commit
      ] ++ lib.optionals config.development.datagrip.enable [ jetbrains.datagrip ];

      file.".ideavimrc" = {
        source = ./ideavimrc;
      };
    };
  };
}
