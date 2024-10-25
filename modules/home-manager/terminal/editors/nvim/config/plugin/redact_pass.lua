-- redact_pass.lua: Disable 'viminfo', 'backup', 'writebackup',
-- 'swapfile', and 'undofile' globally when editing a password in pass(1).
-- This helps prevent password leaks from Vim cache files in case of a compromise.
--
-- Ported from: https://git.zx2c4.com/password-store/tree/contrib/vim

if vim.g.loaded_redact_pass or vim.o.compatible then
  return
end
vim.g.loaded_redact_pass = 1

local function check_args_redact()
  -- Ensure there's one argument and it's the matched file
  if vim.fn.argc() ~= 1 or vim.fn.fnamemodify(vim.fn.argv(0), ':p') ~= vim.fn.expand '<afile>:p' then
    return
  end

  -- Disable all the leaky options globally
  vim.o.backup = false
  vim.o.writebackup = false
  vim.o.swapfile = false
  vim.o.viminfo = ''
  if vim.fn.has 'persistent_undo' == 1 then
    vim.o.undofile = false
  end

  -- Notify the user and set a global variable
  vim.notify('Editing password file--disabled leaky options!', vim.log.levels.INFO)
  vim.g.redact_pass_redacted = 1
end

-- Setup autocommands
vim.api.nvim_create_augroup('redact_pass', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
  group = 'redact_pass',
  pattern = {
    '/dev/shm/pass.?*/?*.txt',
    '/dev/shm/gopass*/secret',
    '$TMPDIR/pass.?*/?*.txt',
    '/tmp/pass.?*/?*.txt',
  },
  callback = check_args_redact,
})

-- macOS specific workaround for temporary directory structure
if vim.fn.has 'mac' == 1 then
  vim.api.nvim_create_autocmd('VimEnter', {
    group = 'redact_pass',
    pattern = '/private/var/?*/pass.?*/?*.txt',
    callback = check_args_redact,
  })
end
