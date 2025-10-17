_: {
  config = {
    wayland.windowManager.sway.config.window.commands = [
      {
        command = "inhibit_idle fullscreen";
        criteria.app_id = "firefox";
      }
      {
        command = "move to scratchpad";
        criteria.app_id = "org.telegram.desktop";
      }
      {
        command = "move to scratchpad";
        criteria.app_id = "com.reciperium.temporis";
      }
      {
        command = "move to scratchpad";
        criteria.app_id = "Slack";
      }
      {
        command = "move to scratchpad";
        criteria = {
          app_id = "musicPlayer";
        };
      }
      {
        command = "move to scratchpad";
        criteria = {
          app_id = "orgMode";
        };
      }
      {
        command = "move to scratchpad";
        criteria = {
          app_id = "hnMode";
        };
      }
    ];
  };
}
