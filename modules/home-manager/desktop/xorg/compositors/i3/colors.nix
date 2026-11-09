{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.desktop.xorg.compositors.i3.enable {
    xsession.windowManager.i3.config.colors = let
      colors = config.colorScheme.palette;
      hex = c: "#${c}";
    in {
      background = hex colors.base07;

      focused = {
        border = hex colors.base05;
        background = hex colors.base0D;
        text = hex colors.base00;
        indicator = hex colors.base0D;
        childBorder = hex colors.base0D;
      };
      focusedInactive = {
        border = hex colors.base01;
        background = hex colors.base01;
        text = hex colors.base05;
        indicator = hex colors.base03;
        childBorder = hex colors.base01;
      };
      unfocused = {
        border = hex colors.base01;
        background = hex colors.base00;
        text = hex colors.base05;
        indicator = hex colors.base01;
        childBorder = hex colors.base01;
      };
      urgent = {
        border = hex colors.base08;
        background = hex colors.base08;
        text = hex colors.base00;
        indicator = hex colors.base08;
        childBorder = hex colors.base08;
      };
      placeholder = {
        border = hex colors.base00;
        background = hex colors.base00;
        text = hex colors.base05;
        indicator = hex colors.base00;
        childBorder = hex colors.base00;
      };
    };
  };
}
