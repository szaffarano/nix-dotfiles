{
  config,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    sessionVariables = {
      EDITOR = "nvim";
    };
    zplug = {
      enable = true;
      plugins = [
        {
          name = "mafredri/zsh-async";
          tags = ["defer:0"];
        }
        {
          name = "zsh-users/zsh-syntax-highlighting";
          tags = ["defer:3"];
        }
        {name = "zpm-zsh/clipboard";}
        {name = "zsh-users/zsh-autosuggestions";}
        {
          name = "wfxr/forgit";
          tags = ["defer:1"];
        }
        {name = "zsh-users/zsh-completions";}
        {
          name = "hlissner/zsh-autopair";
          tags = ["defer:2"];
        }
        {
          name = "lib/completion";
          tags = ["from:oh-my-zsh"];
        }
        {
          name = "lib/grep";
          tags = ["from:oh-my-zsh"];
        }
        {
          name = "lib/history";
          tags = ["from:oh-my-zsh"];
        }
        {
          name = "lib/directories";
          tags = ["from:oh-my-zsh"];
        }
      ];
    };
    shellAliases = {
      update = "sudo nixos-rebuild switch";
      ls = "ls --color";
      ll = "ls -l";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

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
