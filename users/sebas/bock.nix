{ outputs, pkgs, ... }:
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

  desktop.enable = false;
  terminal.cli = {
    ncspot.enable = false;
    cloud.enable = false;
  };

  services.syncthing.enable = false;
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
        yarn = "latest";
      };
    };
  };

  sound.enable = false;
  home.packages = with pkgs; [
    sops
    ssh-to-age
  ];
}
