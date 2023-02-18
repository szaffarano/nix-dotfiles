{ config, lib, ... }: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    settings = {
      character = {
        success_symbol = "[\\$](bold green)";
        error_symbol = "[\\$](bold red)";
      };
      directory = {
        truncate_to_repo = false;
        fish_style_pwd_dir_length = 1;
        read_only = "";
      };
      battery = {
        charging_symbol = "⚡";
        discharging_symbol = "🔋";
        unknown_symbol = "?";
        full_symbol = "☻";
      };
      hostname.ssh_only = false;
      package.disabled = true;
      status.disabled = false;
      username.show_always = true;
    };
  };
}
