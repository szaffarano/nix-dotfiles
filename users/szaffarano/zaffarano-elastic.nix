{ pkgs, inputs, ... }:
{
  home = {
    custom.features.enable = [ ];
    packages = [
      (inputs.nixpkgs-bazel-5_1_1.legacyPackages.${pkgs.hostPlatform.system}.bazel_5.overrideAttrs (_: {
        flag = "rebuilt";
      }))
      pkgs.mercurial
      (pkgs.bats.withLibraries (p: [
        p.bats-support
        p.bats-assert
        p.bats-file
        p.bats-detik
      ]))
    ];
    sessionVariables = {
      LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [
        pkgs.systemd
        pkgs.libgcc.lib
      ]}";
    };
  };

  desktop = {
    enable = true;
    wayland.compositors.hyprland.enable = true;
    wayland.compositors.sway.enable = false;
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

  programs.mise.enable = true;

  sound.enable = true;
}
