{ pkgs, nix, nixpkgs, config, lib, ... }: {
  imports = [ ];
  environment.systemPackages = [ ];

  fonts = {
    fontDir.enable = true;
    fonts = [ ];
  };

  programs.zsh.enable = true;

  system.stateVersion = 4;
  users = { users.szaffarano = { home = /Users/szaffarano; }; };

  nix = {
    nixPath = lib.mkForce [ "nixpkgs=${nixpkgs}" ];
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    distributedBuilds = true;
    buildMachines = [{ }];
  };
  services.nix-daemon.enable = true;
}
