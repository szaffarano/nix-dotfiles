{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.terminal.cli.tools;
in
  with lib; {
    options.terminal.cli.tools.enable = mkEnableOption "tools";

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        atop
        broot # interactive tree view, a fuzzy search
        btop
        czkawka # duplicate files finder
        du-dust
        duf # Disk Usage/Free Utility - a better 'df' alternative
        file
        gawk
        gnumake
        htop
        icdiff # Side-by-side highlighted command line diffs
        jless
        lshw
        nodePackages.json-diff
        openssl
        p7zip
        psmisc # A set of small useful utilities that use the proc filesystem
        rsync
        scc # analyze LOC and other code metrics
        sd # sed replacement
        shellcheck
        shfmt
        strace
        tree
        unzip
        usbutils
        which
        yq-go
      ];
    };
  }
