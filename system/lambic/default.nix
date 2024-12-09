{ flakeRoot
, config
, pkgs
, ...
}:
let
  hostName = "lambic";
  userName = "sebas";
  email = "sebas@zaffarano.com.ar";

  sebas = import "${flakeRoot}/modules/nixos/users/sebas.nix" { inherit userName hostName email; };
in
{
  imports = [
    "${flakeRoot}/modules/nixos"
    sebas
  ];

  networking = {
    inherit hostName;
    useDHCP = true;
    wireless = {
      enable = true;
      secretsFile = config.sops.secrets.wpa.path;
      networks."Midas 2.4GHz".pskRaw = "ext:NET01_PSK";
      extraConfig = "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel";
    };
    networkmanager.enable = false;
  };

  # bcm2711 for rpi 3, 3+, 4, zero 2 w
  # bcm2712 for rpi 5
  # See the docs at:
  # https://www.raspberrypi.com/documentation/computers/linux_kernel.html#native-build-configuration
  raspberry-pi-nix.board = "bcm2711";

  hardware = {
    raspberry-pi = {
      config = {
        all = {
          base-dt-params = {
            BOOT_UART = {
              value = 1;
              enable = true;
            };
            uart_2ndstage = {
              value = 1;
              enable = true;
            };
          };
          dt-overlays = {
            disable-bt = {
              enable = true;
              params = { };
            };
          };
        };
      };
    };
  };

  security.rtkit.enable = true;

  services.pipewire = {
    enable = false;
    alsa.enable = false;
    alsa.support32Bit = false;
    pulse.enable = false;
  };

  nixos.custom.features.enable = [
    "sensible"
    "home-manager"
    "yubikey"
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib
    ];
  };

  sops.secrets = {
    wpa = {
      sopsFile = ./secrets.wpa;
      format = "binary";
    };
    sebas-password = {
      sopsFile = ./secrets.yaml;
      neededForUsers = true;
    };
  };

  system.stateVersion = "24.11";
}
