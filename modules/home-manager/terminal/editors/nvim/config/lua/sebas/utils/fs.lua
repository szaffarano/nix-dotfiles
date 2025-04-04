local M = {}

function M.join(...)
  return table.concat(vim.iter(...):flatten():totable(), '/')
end

return M
