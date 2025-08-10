_: {
  config = {
    wayland.windowManager.sway.config.floating.criteria = [
      {app_id = "org.pulseaudio.pavucontrol";}
      {app_id = "zenity";}
      {
        title = "Settings";
        app_id = "^(?!firefox$).*";
      }
      {
        class = "zoom";
        app_id = "^(?!firefox$).*";
      }
      {app_id = "nm-connection-editor";}
      {app_id = "blueberry.py";}
      {app_id = "transmission-qt";}
      {app_id = "floating-terminal";}
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
      {app_id = "org.keepassxc.KeePassXC";}
    ];
  };
}
