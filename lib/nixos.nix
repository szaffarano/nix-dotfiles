{ self, nixpkgs, ... }@inputs:
config:
let
  configFile = "${self}/users/${config.user.name}/${config.host.name}.nix";
in
nixpkgs.lib.nixosSystem {
  modules = [
    inputs.nix-index-database.nixosModules.nix-index
    inputs.home-manager.nixosModules.home-manager

    "${self}/modules/nixos"
    "${self}/system/${config.host.name}"
    (
      { lib, pkgs, ... }@params:
      let
        hashedPasswordFile = params.config.sops.secrets."${config.user.name}-password".path;
        extraGroups =
          [
            "wheel"
            "networkmanager"
            "video"
            "audio"
          ]
          ++ (lib.optionals params.config.virtualisation.libvirtd.enable [ "libvirtd" ])
          ++ (lib.optionals params.config.virtualisation.docker.enable [ "docker" ]);
      in
      {
        config = {
          networking = {
            domain = lib.mkDefault "zaffarano.com.ar";
            hostName = config.host.name;
          };
          users.mutableUsers = nixpkgs.lib.mkDefault false;
          users.users."${config.user.name}" = {
            inherit hashedPasswordFile;
            inherit extraGroups;
            isNormalUser = true;
            shell = pkgs.zsh;
            openssh.authorizedKeys.keys = config.user.authorizedKeys;
          };
        };
      }
    )
    {
      home-manager = {
        useGlobalPkgs = false;
        useUserPackages = true;
        users.${config.user.name} =
          { lib, ... }@params:
          {
            imports = [
              inputs.nix-colors.homeManagerModule
              inputs.nix-index-database.hmModules.nix-index
              inputs.nur.nixosModules.nur
              "${self}/modules/home-manager"

              configFile
            ];
            config = {
              git = lib.mkIf params.config.git.enable {
                user = {
                  name = config.user.fullName;
                };
              };
            };
          };
      };
    }
  ];
  specialArgs = {
    inherit inputs;
    outputs = self.outputs;
  };
}
