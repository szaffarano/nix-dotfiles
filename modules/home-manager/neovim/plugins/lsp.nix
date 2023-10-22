{
  # TODO:
  # - grammarly
  programs.nixvim.plugins = {
    lsp = {
      enable = true;

      keymaps = {
        silent = true;
        diagnostic = {
          # Navigate in diagnostics
          "<leader>k" = "goto_prev";
          "<leader>j" = "goto_next";
        };

        lspBuf = {
          gd = "definition";
          gD = "references";
          gt = "type_definition";
          gi = "implementation";
          K = "hover";
          "<F2>" = "rename";
        };
      };

      servers = {
        bashls = {
          enable = true;
          filetypes = [ "sh" "zsh" "bash" ];
        };
        clangd.enable = true;
        gopls.enable = true;
        jsonls.enable = true;
        lua-ls.enable = true;
        nil_ls.enable = true;
        pyright.enable = true;
        rust-analyzer.enable = true;
        texlab.enable = true;
        tsserver.enable = true;
        yamlls.enable = true;
      };
    };
  };
}
