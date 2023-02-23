{ self, ... }@inputs:
user: host: system:
let
  config-file = import "${self}/hosts/${user}@${host}/home.nix" inputs;
  # home-directory = "/home/${user}";

in
inputs.darwin.lib.darwinSystem {
  system = system;
  modules = [
    ./configuration.nix
    inputs.home-manager.darwinModules.home-manager
    {
      inputs.home-manager.useGlobalPkgs = true;
      inputs.home-manager.useUserPackages = true;
      inputs.home-manager.users."${user}" = import config-file;
    }
  ];
}

# inputs.home-manager.lib.homeManagerConfiguration {
#   pkgs = import inputs.nixpkgs {
#     inherit system;
#     config.allowUnfreePredicate = pkg:
#       builtins.elem (inputs.nixpkgs.lib.getName pkg) [
#         "dropbox"
#         "grammarly"
#         "lastpass-password-manager"
#         "skypeforlinux"
#         "slack"
#         "zoom"
#       ];
#     overlays = self.overlays;
#   };
#
#   modules = builtins.attrValues self.homeModules ++ [
#     config-file
#     inputs.nur.nixosModules.nur
#     {
#       home = {
#         username = user;
#         homeDirectory = home-directory;
#         stateVersion = "22.11";
#       };
#     }
#   ];
# }
