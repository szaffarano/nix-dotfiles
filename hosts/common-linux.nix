{ pkgs, ... }: {
  imports = [ ../programs/sway ];

  programs.home-manager.enable = true;

  services.blueman-applet.enable = true;

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
    xdg-utils
    copyq

    zeal
  ];

  programs.ncspot = {
    enable = true;
    package = pkgs.ncspot.override { withALSA = false; };
  };
}
