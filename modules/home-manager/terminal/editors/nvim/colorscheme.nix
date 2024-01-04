{
  programs.nixvim = {
    colorschemes = {
      kanagawa = {
        enable = true;
      };
      catppuccin = {
        enable = false;
        flavour = "frappe";
        showBufferEnd = true;
      };
    };
  };
}
