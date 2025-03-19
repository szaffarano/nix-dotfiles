{config, ...}: {
  config = {
    wayland.windowManager.sway.config.colors = let
      colors = config.colorScheme.palette;
    in {
      background = colors.base07;

      focused = {
        border = colors.base05;
        background = colors.base0D;
        text = colors.base00;
        indicator = colors.base0D;
        childBorder = colors.base0D;
      };
      focusedInactive = {
        border = colors.base01;
        background = colors.base01;
        text = colors.base05;
        indicator = colors.base03;
        childBorder = colors.base01;
      };
      unfocused = {
        border = colors.base01;
        background = colors.base00;
        text = colors.base05;
        indicator = colors.base01;
        childBorder = colors.base01;
      };
      urgent = {
        border = colors.base08;
        background = colors.base08;
        text = colors.base00;
        indicator = colors.base08;
        childBorder = colors.base08;
      };
      placeholder = {
        border = colors.base00;
        background = colors.base00;
        text = colors.base05;
        indicator = colors.base00;
        childBorder = colors.base00;
      };
    };
  };
}
