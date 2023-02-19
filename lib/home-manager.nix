{ self, ... }@inputs:
user: host: system:
let
  config-file = import "${self}/hosts/${user}@${host}/home.nix" inputs;
  home-directory = "/home/${user}";

in inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfreePredicate = pkg:
      builtins.elem (inputs.nixpkgs.lib.getName pkg) [
        "dropbox"
        "grammarly"
        "lastpass-password-manager"
        "skypeforlinux"
        "slack"
        "zoom"
      ];
    overlays = self.overlays;
  };

  modules = builtins.attrValues self.homeModules ++ [
    config-file
    inputs.nur.nixosModules.nur
    {
      home = {
        username = user;
        homeDirectory = home-directory;
        stateVersion = "22.11";
      };
    }
  ];
}
