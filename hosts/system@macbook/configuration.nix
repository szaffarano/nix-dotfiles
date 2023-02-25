{ pkgs, lib, ... }@inputs: {
  nix.settings.substituters = [ "https://cache.nixos.org/" ];
  nix.settings.trusted-public-keys =
    [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
  nix.settings.trusted-users = [ "@admin" ];
  nix.configureBuildUsers = true;

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;

  services.sketchybar = {
    enable = true;
    config = builtins.readFile ./sketchybar/sketchybarrc.py;
    plugins = ./sketchybar/plugins;
  };

  environment.systemPackages = [ ];

  programs.nix-index.enable = true;

  fonts.fontDir.enable = true;
  fonts.fonts = [ ];

  system.defaults = {
    loginwindow = {
      GuestEnabled = false;
      SHOWFULLNAME = false;
    };

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark"; # set dark mode
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 20;
      KeyRepeat = 1;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      _HIHideMenuBar = true;
    };

    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 1.0;
      tilesize = 50;
      mru-spaces = false;
      orientation = "right";
      showhidden = true;
      show-recents = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
      QuitMenuItem = true;
      FXEnableExtensionChangeWarning = false;
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };

  };

  system.keyboard = {
    remapCapsLockToEscape = true;
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  system.stateVersion = 4;

  security.pam.enableSudoTouchIdAuth = true;

  users = { users = inputs.currentUser; };
}
