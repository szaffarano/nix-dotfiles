{
  pkgs,
  lib,
  ...
}: {
  home = {
    custom = {
      features.enable = [];
      allowed-unfree-packages = [pkgs.confluent-cli];
    };
    packages = with pkgs; [
      asciinema
      asciinema-agg
      bubblewrap
      confluent-cli
      devenv
      devpod
      helix
      mullvad-browser
      openssl
      pkg-config
      swagger-codegen
      upx
      wl-clipboard
      yara-x
    ];
  };

  desktop = {
    enable = true;
    wayland = {
      compositors.hyprland.enable = true;
      compositors.sway.enable = false;
    };
  };
  services = {
    flameshot = {
      enable = false;
      package = pkgs.flameshot-grim;
    };
    syncthing.enable = true;
  };
  terminal.cli = {
    cloud.enable = true;
  };
  develop = {
    enable = true;
    asm.enable = true;
    emacs.enable = false;
    idea = {
      enable = true;
      ultimate = true;
    };
    ocaml.enable = false;
    python.enable = true;
    nodejs.enable = true;
    rust.enable = true;
    zig.enable = true;
  };

  terminal = {
    zsh.enable = false;
    fish.enable = true;
  };

  programs = {
    mise.enable = true;
    nix-index.enable = true;
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  systemd.user.services.monitor-elastic-endpoint = {
    Unit = {
      Description = "Monitor elastic-endpoint process";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${lib.getExe pkgs.check-elastic-endpoint}";
    };
  };

  systemd.user.timers.monitor-elastic-endpoint = {
    Unit = {
      Description = "Run elastic-endpoint monitor every hour";
      PartOf = ["graphical-session.target"];
    };

    Timer = {
      OnBootSec = "1min";
      OnUnitActiveSec = "1h";
      Persistent = true;
    };

    Install = {
      WantedBy = ["timers.target"];
    };
  };

  sound.enable = true;
}
