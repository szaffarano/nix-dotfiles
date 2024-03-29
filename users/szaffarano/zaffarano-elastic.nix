{ inputs, outputs, ... }: {

  git = {
    enable = true;
    user = {
      name = outputs.user.fullName;
    };
  };

  gpg = {
    enable = true;
  };

  colorscheme = inputs.nix-colors.colorschemes.tokyo-night-storm;

  desktop.enable = true;
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
  };

  terminal.zsh = {
    enable = true;
    extras = [ "local" "binds" "breeze" "ocaml" ];
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
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
      };
    };
  };

  sound.enable = true;
}
