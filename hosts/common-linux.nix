{ pkgs, ... }: {
  programs.home-manager.enable = true;

  sway.enable = true;
  xdg.config.enable = true;
  gpg-agent.enable = true;

  copyq.enable = true;
  firefox.enable = true;
  programs.chromium.enable = true;
  services.syncthing.enable = true;

  home.packages = with pkgs; [
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science es ]))
    playerctl
    networkmanager
    blueberry

    obsidian

    # screenshots
    grim
    slurp
    swappy
    sway-contrib.grimshot

    imagemagick
    pavucontrol
    pasystray
    qview

    speedcrunch
    transmission-qt
    anki
    calibre
    tdesktop
    weechat

    gnome.zenity # calendar
    zeal
    virt-manager
  ];
}
