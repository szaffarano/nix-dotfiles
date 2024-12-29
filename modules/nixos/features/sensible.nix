{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  feature_name = "sensible";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in {
  imports = [inputs.nix-index-database.nixosModules.nix-index];

  config = {
    services = lib.mkIf enabled {
      envfs.enable = true;
      fwupd.enable = true;
      openssh.enable = true;
      tailscale.enable = true;
      udisks2.enable = true;
    };

    networking = lib.mkIf enabled {domain = "zaffarano.com.ar";};

    boot.kernel.sysctl = lib.mkIf enabled {
      "fs.inotify.max_user_watches" = 512000;
      "fs.inotify.max_queued_events" = 512000;
    };

    environment.systemPackages = with pkgs;
      lib.mkIf enabled [
        cachix
        curl
        e2fsprogs
        git
        gptfdisk
        libinput
        mkpasswd
        neovim-unwrapped
        p7zip
        pciutils
        pv
        rclone
        restic
        udisks
        unzip
        usbutils
        wget
        zip
      ];

    programs = lib.mkIf enabled {
      nix-index = {
        enableZshIntegration = false;
        enableBashIntegration = false;
      };
      nix-index-database.comma.enable = true;
      zsh.enable = true;
    };

    zramSwap.enable = enabled;

    nixos.custom.features.register = feature_name;
  };
}
