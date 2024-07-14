{ pkgs, ... }:
{
  home.custom.features.enable = [ ];

  desktop = {
    enable = true;
    wayland.compositors.hyprland.enable = false;
    wayland.compositors.sway.enable = true;
  };
  terminal.cli.cloud.enable = true;
  services.syncthing.enable = true;
  programs.nix-index.enable = true;
  develop = {
    enable = true;
    idea = {
      enable = false;
      ultimate = false;
    };
    ocaml.enable = false;
    asm.enable = true;
  };

  terminal.zsh = {
    enable = true;
    extras = [
      "local"
      "binds"
      "breeze"
      "ocaml"
    ];
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  home.packages = [ ];

  home.sessionVariables = {
    LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [ pkgs.systemd ]}";
  };

  programs.mise.enable = true;

  sound.enable = true;
}
