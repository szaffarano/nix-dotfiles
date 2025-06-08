return {
  {
    'olimorris/codecompanion.nvim',
    opts = {
      keys = {
        {
          '<C-a>',
          '<cmd>CodeCompanionActions<CR>',
          desc = 'Open the action palette',
          mode = { 'n', 'v' },
        },
        {
          '<Leader>A',
          '<cmd>CodeCompanionChat Toggle<CR>',
          desc = 'Toggle a chat buffer',
          mode = { 'n', 'v' },
        },
        {
          '<LocalLeader>a',
          '<cmd>CodeCompanionChat Add<CR>',
          desc = 'Add code to a chat buffer',
          mode = { 'v' },
        },
      },
      extensions = {
        history = {
          enabled = true,
          opts = {
            keymap = 'gh',
            save_chat_keymap = 'sc',
            auto_save = false,
            auto_generate_title = true,
            continue_last_chat = false,
            delete_on_clearing_chat = false,
            picker = 'snacks',
            enable_logging = false,
            dir_to_save = vim.fn.stdpath 'data' .. '/codecompanion-history',
          },
        },
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
        vectorcode = {
          opts = {
            add_tool = true,
          },
        },
      },
      adapters = {
        openai = function()
          return require('codecompanion.adapters').extend('openai', {
            opts = {
              stream = true,
            },
            env = {
              api_key = 'cmd:get-keepass-entry sebas@zaffarano.com.ar "https://platform.openai.com"',
            },
            schema = {
              model = {
                default = function()
                  return 'gpt-4.1'
                end,
              },
            },
          })
        end,
        ollama = function()
          return require('codecompanion.adapters').extend('ollama', {
            schema = {
              model = {
                default = 'deepseek-r1:1.5b',
              },
              num_ctx = {
                default = 20000,
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = 'openai',
        },
        inline = {
          adapter = 'openai',
        },
        cmd = {
          adapter = 'openai',
        },
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      {
        'ravitemer/mcphub.nvim',
        build = 'npm install -g mcp-hub@latest',
        config = function()
          require('mcphub').setup()
        end,
      },
      'stevearc/aerial.nvim',
      'ravitemer/codecompanion-history.nvim',
      { 'Davidyz/VectorCode', version = '*', build = 'pipx upgrade vectorcode' },
    },
  },
}
