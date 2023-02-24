{ self, ... }@input:
user: host: system:
let
  config-file = import "${self}/hosts/${user}@${host}/home.nix" input;
  extraModules = import ../modules input;
  ex = import ../../modules/bat input;

in
input.darwin.lib.darwinSystem {
  system = system;
  modules = [
    "${self}/configuration.nix"
    input.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${user}" = config-file;
      # home-manager.extraSpecialArgs = {
      #   inherit self input ex;
      # };
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
