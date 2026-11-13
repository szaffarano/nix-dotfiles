{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.desktop.xorg.compositors.i3.enable {
    xsession.windowManager.i3.config.window.commands = [
      {
        command = "move to scratchpad";
        criteria.class = "TelegramDesktop";
      }
      {
        command = "move to scratchpad";
        criteria.class = "temporis";
      }
      {
        command = "move to scratchpad";
        criteria.class = "Slack";
      }
      {
        command = "move to scratchpad";
        criteria.instance = "musicPlayer";
      }
      {
        command = "move to scratchpad";
        criteria.instance = "orgMode";
      }
      {
        command = "move to scratchpad";
        criteria.instance = "hnMode";
      }
      {
        command = "move to scratchpad";
        criteria.instance = "termScratch";
      }
    ];
  };
}
