{
  programs.nixvim.autoCmd = [
    # Vertically center document when entering insert mode
    {
      event = "InsertEnter";
      command = "norm zz";
    }

    # Open help in a vertical split
    {
      event = "FileType";
      pattern = "help";
      command = "wincmd L";
    }

    # Set indentation to 2 spaces for nix files
    {
      event = "FileType";
      pattern = "nix";
      command = "setlocal tabstop=2 shiftwidth=2";
    }

    # Enable spellcheck for some filetypes
    {
      event = "FileType";
      pattern = [
        "tex"
        "latex"
        "markdown"
        "org"
      ];
      command = "setlocal spell spelllang=en,es";
    }

    # Highlight on yank
    # See `:help vim.highlight.on_yank()`
    {
      event = "TextYankPost";
      pattern = "*";
      callback = {
        __raw = ''
          function()
            vim.highlight.on_yank {
              higroup = 'IncSearch',
              timeout = 40,
            }
          end
        '';
      };
    }
  ];
}
