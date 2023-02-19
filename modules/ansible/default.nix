_:
{ config, lib, pkgs, ... }: {
  options.ansible.enable = lib.mkEnableOption "ansible";

  config = lib.mkIf config.ansible.enable {
    home.packages = with pkgs; [ ansible ansible-lint ];
  };
}
