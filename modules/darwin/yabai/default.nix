{pkgs, ...}: {
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    package = pkgs.yabai;

    config = {
      external_bar = "all:0:28";

      mouse_follows_focus = "off";
      focus_follows_mouse = "autofocus";

      window_placement = "second_child";
      window_topmost = "off";

      window_opacity = "off";
      window_opacity_duration = 0.0;
      window_shadow = "off";

      active_window_opacity = 1.0;
      window_border_width = 2;
      window_border = "on";

      normal_window_opacity = 0.9;
      split_ratio = 0.5;
      auto_balance = "on";

      mouse_modifier = "alt";
      mouse_action1 = "move";
      mouse_action2 = "resize";

      layout = "bsp";
      top_padding = 3;
      bottom_padding = 3;
      left_padding = 3;
      right_padding = 3;
      window_gap = 3;

      active_window_border_color = "0xff775759";
      normal_window_border_color = "0xff505050";
    };
    extraConfig = builtins.readFile ./yabairc;
  };
}
