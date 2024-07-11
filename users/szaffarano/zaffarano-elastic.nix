{ pkgs, inputs, ... }:
{
  home.custom.features.enable = [ ];

  desktop = {
    enable = true;
    wayland.compositors.hyprland.enable = false;
    wayland.compositors.sway.enable = true;
  };
  services.flameshot = {
    enable = true;
    package = pkgs.flameshot-grim;
  };
  terminal.cli.cloud.enable = true;
  services.syncthing.enable = true;
  programs.nix-index.enable = true;
  develop = {
    enable = true;
    idea = {
      enable = true;
      ultimate = true;
    };
    ocaml.enable = true;
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

  home.packages = [ inputs.nixpkgs-bazel-5_1_1.legacyPackages.${pkgs.hostPlatform.system}.bazel_5 ];

  home.sessionVariables = {
    LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [
      pkgs.systemd
      (pkgs.libgcc.lib)
    ]}";
  };

  programs.mise.enable = true;

  sound.enable = true;
}
