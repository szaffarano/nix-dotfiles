{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "-";
        action = ":Oil<cr>";
        options.silent = true;
      }
    ];

    # A vim-vinegar like file explorer that lets you edit your filesystem like a normal Neovim buffer.
    plugins.oil = {
      enable = true;
      skipConfirmForSimpleEdits = true;
    };
  };
}
