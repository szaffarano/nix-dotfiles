{ pkgs, ... }: {
  imports = [
    ./comment.nix
    ./completion.nix
    ./copilot.nix
    ./git.nix
    ./illuminate.nix
    ./indent-blankline.nix
    ./lsp.nix
    ./lualine.nix
    ./oil.nix
    ./orgmode.nix
    ./telescope.nix
    ./treesitter.nix
    ./wiki-vim.nix
    ./which-key.nix
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
        triggerEvents = [ "BufLeave" "BufWinLeave" "FocusLost" ];
      };

      nvim-autopairs.enable = true;

      nvim-colorizer = {
        enable = true;
        userDefaultOptions.names = false;
      };

      lastplace.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      vim-sleuth # manage shiftwitd and expand tab automagically
      vim-gnupg # transparent gpg encryption
      neoformat # TODO: is it still needed?
    ];
  };
}
