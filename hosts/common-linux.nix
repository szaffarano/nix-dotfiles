{ pkgs, ... }: {
  programs.home-manager.enable = true;

  sway.enable = true;
  xdg.config.enable = true;
  gpg-agent.enable = true;

  copyq.enable = true;
  firefox.enable = true;
  programs.chromium.enable = true;

  home.packages = with pkgs; [
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science es ]))
    playerctl
    networkmanager
    blueberry
    pulseaudioFull

    # screenshots
    grim
    slurp
    swappy
    sway-contrib.grimshot

    imagemagick
    pavucontrol
    qview

    speedcrunch
    transmission-qt
    anki
    calibre
    tdesktop
    slack
    weechat

    zeal
    virt-manager
  ];
}
