{ pkgs, ... }: {
  programs.home-manager.enable = true;

  ncspot.enable = true;
  sway.enable = true;
  xdg.config.enable = true;

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
    anki
    calibre
    tdesktop
    slack
    weechat
    copyq

    zeal
    virt-manager
  ];
}
