{ pkgs, ... }: {
  programs.nixvim = {
    options.completeopt = [ "menu" "menuone" "noselect" ];

    plugins = {
      luasnip.enable = true;
      cmp-buffer.enable = true;
      cmp-fuzzy-path.enable = true;
      cmp_luasnip.enable = true;
      cmp-nvim-lsp-document-symbol.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lua.enable = true;
      cmp-path.enable = true;
      cmp-treesitter.enable = true;
      cmp-zsh.enable = true;

      lspkind = {
        enable = true;

        cmp = {
          enable = true;
          menu = {
            nvim_lsp = "[LSP]";
            nvim_lua = "[api]";
            path = "[path]";
            luasnip = "[snip]";
            buffer = "[buffer]";
          };
        };
      };

      nvim-cmp = {
        enable = true;

        snippet.expand = "luasnip";

        mapping = {
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-e>" = "cmp.mapping.close()"; # TODO: mapping.abort()?
          "<C-n>" = {
            # TODO: behavior = cmp.SelectBehavior.Insert
            modes = [ "i" "s" ];
            action = "cmp.mapping.select_next_item()";
          };
          "<Cp>" = {
            modes = [ "i" "s" ];
            action = "cmp.mapping.select_prev_item()";
          };

          "<C-Space>" = "cmp.mapping.complete()";
          "<c-y>" = "cmp.mapping.confirm({ select = true })";
          "<tab>" = "cmp.config.disable";
        };

        sources = [
          { name = "path"; }
          { name = "copilot"; }
          { name = "nvim_lsp"; }
          { name = "nvim_lua"; }
          { name = "luasnip"; }
          { name = "treesitter"; }
          { name = "orgmode"; }
          {
            name = "buffer";
            # Words from other open buffers can also be suggested.
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
          }
        ];
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      friendly-snippets
    ];

    extraConfigLua = ''
      require("luasnip.loaders.from_vscode").lazy_load()

      local luasnip = require 'luasnip'

      -- TODO: move to nixvim keymaps
      -- <c-k> is my expansion key
      -- this will expand the current item or jump to the next item within the snippet.
      vim.keymap.set({ 'i', 's' }, '<c-k>', function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { silent = true })

      -- <c-j> is my jump backwards key.
      -- this always moves to the previous item within the snippet
      vim.keymap.set({ 'i', 's' }, '<c-j>', function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { silent = true })

      -- <c-l> is selecting within a list of options.
      -- This is useful for choice nodes (introduced in the forthcoming episode 2)
      vim.keymap.set('i', '<c-l>', function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end)

      vim.keymap.set('i', '<c-u>', require 'luasnip.extras.select_choice')
    '';
  };
}
