{...}: {
  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        icons = "awesome";
        theme = "semi-native";
        blocks = [
          {
            block = "music";
            format = "$combo.rot-str(20) $play $next|";
            player = "ncspot";
          }
          {
            block = "disk_space";
            unit = "GB";
            warning = 20.0;
            alert = 10.0;
          }
          {
            block = "memory";
            display_type = "memory";
            format_mem = "{mem_used_percents}";
            format_swap = "{swap_used_percents}";
          }
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "load";
            interval = 1;
            format = "{1m}";
          }
          {
            block = "battery";
            format = "$percentage|N/A";
          }
          {
            block = "time";
            interval = 60;
            format = "%a %d/%m %R";
          }
        ];
      };
    };
  };
}
