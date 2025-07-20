return {
  'ravitemer/mcphub.nvim',
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
