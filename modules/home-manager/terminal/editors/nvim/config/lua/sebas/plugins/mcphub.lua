return {
  'ravitemer/mcphub.nvim',
  enabled = false,
  config = function()
    require('mcphub').setup {
      cmd = 'mise',
      cmdArgs = {
        'exec',
        'node@latest',
        '--',
        'mcp-hub',
      },
    }
  end,
}
