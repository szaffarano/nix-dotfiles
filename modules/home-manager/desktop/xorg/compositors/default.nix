{
  config,
  lib,
  pkgs,
  theme,
  ...
}: let
  cfg = config.desktop.xorg.compositors;
  nmAppletCmd = "${pkgs.networkmanagerapplet}/bin/nm-applet";
  paSysTrayCmd = "${pkgs.pasystray}/bin/pasystray";
in
  with lib; {
    imports = [
      ./i3
    ];

    options.desktop.xorg.compositors.enable = mkEnableOption "xorg compositors";

    config = mkIf cfg.enable {
      home.packages = with pkgs; [gsettings-desktop-schemas];

      home.pointerCursor = {
        enable = true;
        package = pkgs.adwaita-icon-theme;
        name = theme.gtk.cursor-theme;
        size = 24;
        x11.enable = true;
        gtk.enable = true;
      };

      xresources.properties = {
        "Xft.dpi" = 144;
      };

      xdg.systemDirs.data = ["${pkgs.networkmanagerapplet}/share"];

      xsession.windowManager.i3.config.startup = lib.mkIf config.desktop.xorg.compositors.i3.enable [
        {
          command = "${nmAppletCmd}";
          notification = false;
        }
        {
          command = "${paSysTrayCmd}";
          notification = false;
        }
      ];

      services.autorandr.enable = true; # optional: runs autorandr on graphical login
      programs.autorandr = {
        enable = true;

        profiles = {
          docked = {
            fingerprint = {
              DP-1 = "00ffffffffffff001e6d5077f8841d0001210104b5462878fa7ba1ae4f44a9260c5054210800d1c0614001010101010101010101010100d200a0f070508030203500b9882100001a000000fd00283c1e873c000a202020202020000000fc004c472048445220344b0a202020000000ff003330314d41504e47515a38340a01af02031f7223090707830100004401030410e2006ae305c000e6060501595952a36600a0f0701f8030203500b9882100001a565e00a0a0a0295030203500b9882100001a023a801871382d40582c4500b9882100001a00000000000000000000000000000000000000000000000000000000000000000000000000000000000080";
              eDP-1 = "00ffffffffffff000daee514000000002f1e0104a51f1178020865975b548e271e505400000001010101010101010101010101010101b43b804a71383440503c680035ad10000018000000fe004e3134304847412d4541310a20000000fe00434d4e0a202020202020202020000000fe004e3134304847412d4541310a20001f";
            };
            config = {
              DP-1 = {
                enable = true;
                primary = true;
                mode = "3840x2160";
                position = "0x0";
              };
              eDP-1 = {
                enable = false;
                mode = "1920x1080";
                position = "3840x0";
              };
            };
          };

          mobile = {
            fingerprint.eDP-1 = "00ffffffffffff000daee514000000002f1e0104a51f1178020865975b548e271e505400000001010101010101010101010101010101b43b804a71383440503c680035ad10000018000000fe004e3134304847412d4541310a20000000fe00434d4e0a202020202020202020000000fe004e3134304847412d4541310a20001f";
            config = {
              eDP-1 = {
                enable = true;
                primary = true;
                mode = "1920x1080";
                position = "0x0";
              };
              DP-1.enable = false;
            };
          };
        };
      };
    };
  }
