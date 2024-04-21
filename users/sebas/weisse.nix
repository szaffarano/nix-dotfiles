{ inputs
, outputs
, pkgs
, ...
}:
{

  git = {
    enable = true;
    user = {
      name = outputs.user.fullName;
      email = outputs.user.email;
      signingKey = outputs.user.gpgKey;
    };
  };

  gpg = {
    enable = true;
    default-key = outputs.user.gpgKey;
    trusted-key = outputs.user.gpgKey;
  };

  colorscheme = inputs.nix-colors.colorschemes.tokyo-night-storm;

  desktop.enable = true;
  terminal.cli.cloud.enable = false;
  services.syncthing.enable = true;
  programs.nix-index.enable = true;
  develop = {
    enable = true;
    idea.enable = false;
    ocaml.enable = false;
  };

  terminal.zsh = {
    enable = true;
    extras = [
      "local"
      "binds"
      "breeze"
    ];
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
      };
    };
  };

  sound.enable = false;
}
