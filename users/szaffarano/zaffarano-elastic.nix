{pkgs, ...}: {
  home = {
    custom = {
      features.enable = [];
      allowed-unfree-packages = with pkgs; [
        vscode
        vscode-extensions.github.copilot
        vscode-extensions.github.copilot-chat
        vscode-extensions.ms-vscode-remote.vscode-remote-extensionpack
        vscode-extensions.ms-vscode-remote.remote-containers
        vscode-with-extensions
        windsurf
      ];
      permitted-insecure-packages = ["python-2.7.18.8"]; # needed by bazel-5.1.1
    };
    packages = with pkgs; [
      asciinema
      asciinema-agg
      bazel_5_1_1
      openssl
      pkg-config
      pkgsCross.mingwW64.stdenv.cc
      pkgsCross.mingwW64.windows.mingw_w64_pthreads
      upx
      (
        vscode-with-extensions.override {
          # When the extension is already available in the default extensions set.
          vscodeExtensions = with vscode-extensions;
            [
              asvetliakov.vscode-neovim
              enkia.tokyo-night
              github.copilot
              github.copilot-chat
              ms-pyright.pyright
              ms-python.python
              ms-vscode-remote.vscode-remote-extensionpack
              ms-vscode-remote.remote-containers
              rust-lang.rust-analyzer
              vscode-icons-team.vscode-icons
            ]
            # Concise version from the vscode market place when not available in the default set.
            ++ vscode-utils.extensionsFromVscodeMarketplace [
            ];
        }
      )
      windsurf
    ];
  };

  desktop = {
    enable = true;
    wayland.compositors.hyprland.enable = false;
    wayland.compositors.sway.enable = true;
  };
  services.flameshot = {
    enable = false;
    package = pkgs.flameshot-grim;
  };
  terminal.cli.cloud.enable = true;
  services.syncthing.enable = true;
  programs.nix-index.enable = true;
  develop = {
    enable = true;
    asm.enable = true;
    idea = {
      enable = true;
      ultimate = true;
    };
    ocaml.enable = false;
    python.enable = true;
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

  programs.mise.enable = true;

  sound.enable = true;
}
