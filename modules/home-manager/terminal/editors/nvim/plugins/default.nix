{ pkgs, ... }: {
  imports = [
    ./comment.nix
    ./completion.nix
    ./copilot.nix
    ./git.nix
    ./harpoon.nix
    ./illuminate.nix
    ./indent-blankline.nix
    ./lsp.nix
    ./lualine.nix
    ./oil.nix
    ./orgmode.nix
    ./telescope.nix
    ./toggleterm.nix
    ./treesitter.nix
    ./which-key.nix
    ./wiki-vim.nix
  ];

  # TODO:
  #  'tpope/vim-unimpaired'
  #  'godlygeek/tabular'
  #  'akinsho/toggleterm.nvim'
  programs.nixvim = {
    plugins = {
      auto-save = {
        enable = true;
        debounceDelay = 500;
        writeAllBuffers = true;
        triggerEvents = [ "FocusLost" ];
      };

      nvim-autopairs.enable = true;

      lastplace.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      vim-gnupg
      harpoon2
    ];
  };
}
