local fmt = string.format

return {
  {
    'olimorris/codecompanion.nvim',
    opts = {
      extensions = {
        history = {
          enabled = true,
          opts = {
            auto_save = true,
            expiration_days = 30,
            picker = 'telescope',
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
                default = 'gpt-4.1-mini',
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
          tools = {
            opts = {
              default_tools = {
                'mcp',
                'vectorcode',
              },
            },
          },
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
              content = 'You are an expert software developer following the commitizen convention specification.',
            },
            {
              role = 'user',
              opts = {
                contains_code = true,
              },
              content = fmt(
                [[
<user_prompt>
Given the git diff listed below, please generate a commit message for me. Keep
the title under 50 characters and wrap message at 72 characters. Format as a
gitcommit code block. You must begin your commits with at least one of these
tags: fix, feat, etc.. And if you introduce a breaking change, then you must
add to your commit body the following BREAKING CHANGE.
Example `fix(commands): bump error when no user provided`.
</user_prompt>

```diff
%s
```]],
                vim.fn.system 'git diff --no-ext-diff --staged'
              ),
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
      'ravitemer/mcphub.nvim',
      'stevearc/aerial.nvim',
      'ravitemer/codecompanion-history.nvim',
      { 'Davidyz/VectorCode', version = '*', build = 'pipx upgrade vectorcode' },
    },
  },
}
