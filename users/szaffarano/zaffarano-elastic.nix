{
  pkgs,
  lib,
  ...
}: {
  home = {
    custom = {
      features.enable = [];
      allowed-unfree-packages = [];
      permitted-insecure-packages = ["python-2.7.18.12"]; # needed by bazel-5.1.1
    };
    packages = with pkgs; [
      asciinema
      asciinema-agg
      bazel_5_1_1
      devpod
      inputs.org-mcp-server.default
      mullvad-browser
      openssl
      pkg-config
      swagger-codegen
      upx
      wl-clipboard
    ];
  };

  desktop = {
    enable = true;
    wayland.compositors.hyprland.enable = false;
    wayland.compositors.sway.enable = true;
  };
  services = {
    flameshot = {
      enable = false;
      package = pkgs.flameshot-grim;
    };
    syncthing.enable = true;
  };
  terminal.cli = {
    zellij.enable = true;
    cloud.enable = true;
    jujutsu.enable = true;
  };
  programs.nix-index.enable = true;
  develop = {
    enable = true;
    asm.enable = true;
    emacs.enable = true;
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

  programs.mise.enable = true;

  sound.enable = true;
}
