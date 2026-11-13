{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.desktop.xorg.compositors.i3.enable {
    xsession.windowManager.i3.config.floating.criteria = [
      {window_role = "pop-up";}
      {window_role = "bubble";}
      {window_role = "dialog";}
      {window_type = "dialog";}

      {class = "Pavucontrol";}
      {instance = "floating";}
      {class = "Zenity";}
      {class = "Nm-connection-editor";}
      {class = ".blueman-manager-wrapped";}
      {class = "Blueman-manager";}
      {class = "transmission-qt";}
      {instance = "floating-terminal";}
      {
        class = "jetbrains-idea-ce";
        title = "Welcome to IntelliJ IDEA";
      }
      {
        class = "jetbrains-idea";
        title = "win0";
      }
      {
        class = "Anki";
        title = "Profiles";
      }
      {
        class = "Anki";
        title = "Add";
      }
      {
        class = "Anki";
        title = "^Browse.*";
      }
      {class = "KeePassXC";}
    ];
  };
}
