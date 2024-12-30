{
  outputs,
  pkgs,
  ...
}: {
  git = {
    enable = true;
    user = {
      inherit (outputs.user) email;
      name = outputs.user.fullName;
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
    spotify.enable = false;
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

  programs.mise.enable = true;

  sound.enable = false;
  home.packages = with pkgs; [
    sops
    ssh-to-age
  ];
}
