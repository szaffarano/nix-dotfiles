_: { pkgs, ... }:

{
  _module.args = {

    theme = {
      waybar = {
        colors = {
          c-bg-primary = "#282828";
          c-fg-primary = "#ebdbb2";
          c-fg-secondary = "#fbf1c7";
          c-critical = "#fb4934";
          c-warning = "#d79921";
          c-ok = "#b9bb26";
          c-muted = "#928374";
          c-neutral = "#83a598";
        };

        fonts = {
          f-family = "sans-serif";
          f-name = "FiraCode Nerd Font";
          f-size = "15px";
        };
      };
    };
  };
}
