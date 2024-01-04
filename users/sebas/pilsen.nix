{ inputs, outputs, ... }: {

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
  terminal.cli.cloud.enable = true;
  services.syncthing.enable = true;
  programs.nix-index.enable = true;
  develop = {
    enable = true;
    idea.enable = true;
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

  programs.rtx.settings = {
    tools = {
      node = "lts";
      python = "latest";
      yarn = "latest";
    };

    settings = {
      verbose = true;
      experimental = true;
    };
  };
}
