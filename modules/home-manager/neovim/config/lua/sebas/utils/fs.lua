local M = {}

function M.join(...)
  return table.concat(vim.tbl_flatten { ... }, '/')
end

return M
