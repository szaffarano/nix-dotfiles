{ lib, config, ... }:
let
  cfg = config.hm;
in
{
  options = with lib; {
    hm.allowed-unfree-packages =
      with types;
      mkOption {
        type = listOf package;
        default = [ ];
        example = [ pkgs.vault-bin ];
        description = ''
          List of packages to configure the nixpkgs.config.allowUnfree option.
          Instead of having a "catch all" true or a centalized predicate, this
          option alows modules to include in this list the non-free packages they
          want to install.
        '';
      };
  };
  config =
    let
      packageNames = map lib.getName cfg.unfree-packages;
    in
    {
      nixpkgs.config.allowUnfreePredicate = lib.mkDefault (
        pkg:
        let
          packageName = lib.getName pkg;
          exists = builtins.elem packageName packageNames;
        in
        if exists then
          builtins.trace "Allowing the non-free package '${packageName}' to be installed" exists
        else
          exists
      );
    };
}
