{
  # TODO:
  # - grammarly
  programs.nixvim = {
    extraConfigLua = "require'lspconfig'.ocamllsp.setup{}";

    keymaps = [
      {
        key = "<leader>rls";
        action = "<cmd>LspRestart<cr>";
        options = {
          desc = "[R]estart [L]anguage [S]erver]";
        };
      }
    ];


    plugins = {
      lsp = {
        enable = true;

        keymaps = {
          silent = true;
          diagnostic = {
            # Navigate in diagnostics
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
            "<leader>e" = "open_float";
          };

          lspBuf = {
            gd = "definition";
            gD = "references";
            gt = "type_definition";
            gi = "implementation";
            ga = "code_action";
            "<C-M-l>" = "format";
            K = "hover";
            "<S-F6>" = "rename";
          };
        };

        servers = {
          bashls = {
            enable = true;
            filetypes = [ "sh" "zsh" "bash" ];
          };
          terraformls.enable = true;
          clangd.enable = true;
          gopls.enable = true;
          jsonls.enable = true;
          lua-ls.enable = true;
          nil_ls.enable = true;
          pyright.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          texlab.enable = true;
          tsserver.enable = true;
          yamlls.enable = true;
        };
      };
    };
  };
}
