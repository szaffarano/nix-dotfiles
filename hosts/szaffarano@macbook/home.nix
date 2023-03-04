{ self, ... }:
{ config, lib, pkgs, inputs, ... }: {

  # darwin.services.sketchybar = {
  #   enable = true;
  # };
  #

  imports = [ ../common.nix ];

  git = {
    enable = true;
    user = {
      name = "Sebastián Zaffarano";
      email = "sebastian.zaffarano@wolt.com";
      signingKey = "0x1DAFA4CA33CA433D";
    };
  };

  gpg = {
    enable = true;
    default-key = "0x1DAFA4CA33CA433D";
    trusted-key = "0x14F35C58A2191587";
  };

  programs.zsh.profileExtra = ''
    export PATH="$PATH:/opt/homebrew/bin:/opt/homebrew/sbin";
  '';

  flameshot = {
    enable = true;
    settings = {
      General = {
        contrastOpacity = 145;
        copyOnDoubleClick = true;
        drawColor = "#0000ff";
        drawFontSize = 7;
        startupLaunch = true;
      };
      Shortcuts = { TYPE_COPY = "Return"; };
    };
  };

  kitty.enable = true;
  home.stateVersion = "22.11";
  home.packages = with pkgs; [
    bottom
    vault
    aws-vault
    awscli2
    aws-iam-authenticator

    slack
    zoom-us
  ];
}
