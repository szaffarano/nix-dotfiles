local fmt = string.format

return {
  {
    'olimorris/codecompanion.nvim',
    opts = {
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
                  return 'gpt-4.1-mini'
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
      prompt_library = {
        ['Generate a Commit Message following commitizen convention'] = {
          strategy = 'chat',
          description = 'Generate a commit message following commitizen convention',
          opts = {
            index = 10,
            is_default = true,
            is_slash_cmd = true,
            short_name = 'commitizen',
            auto_submit = true,
            mapping = '<LocalLeader>Cc',
          },
          prompts = {
            {
              role = 'system',
              content = [[You are an expert software developer following the commitizen convention specification.]],
            },
            {
              role = 'user',
              content = fmt(
                [[
<user_prompt>
  Given the git diff listed below, please generate a commit message for me.
  Keep the title under 50 characters and wrap message at 72 characters. Format
  as a gitcommit code block:
</user_prompt>

```diff
%s
```]],
                vim.fn.system 'git diff --no-ext-diff --staged'
              ),
              opts = {
                contains_code = true,
              },
            },
          },
        },
      },
    },
    keys = {
      {
        '<Leader>Ca',
        '<cmd>CodeCompanionActions<CR>',
        desc = 'Open the action palette',
        mode = { 'n', 'v' },
      },
      {
        '<Leader>Cc',
        '<cmd>CodeCompanionChat Toggle<CR>',
        desc = 'Toggle a chat buffer',
        mode = { 'n', 'v' },
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
