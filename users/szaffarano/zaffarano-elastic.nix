{ inputs, pkgs, ... }:
{
  colorscheme = inputs.nix-colors.colorschemes.tokyo-night-storm;

  home.custom.features.enable = [ ];

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

  home.sessionVariables = {
    MISE_LEGACY_VERSION_FILE_DISABLE_TOOLS = "terraform";
  };

  programs.mise = {
    settings = {
      verbose = false;
      experimental = true;
      all_compile = false;
      python_compile = false;
      node_compile = false;
    };

    globalConfig = {
      tools = {
        node = "lts";
        python = "latest";
        yarn = "latest";
        java = "temurin-21.0.2+13.0.LTS";
        terraform = "latest";
        tflint = "latest";
      };
    };
  };

  sound.enable = true;
}
