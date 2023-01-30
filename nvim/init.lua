if not pcall(require, "impatient") then
	print("impatient plugin is not installed")
end

local bootstrapped = require("sebas.bootstrap")()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("sebas.disable_builtin")

require("sebas.options")
require("sebas.keymaps")
require("sebas.plugins").setup(bootstrapped)
require("sebas.lsp")

if bootstrapped then
	print("==================================")
	print("    Plugins are being installed")
	print("    Wait until Packer completes,")
	print("       then restart nvim")
	print("==================================")
	return
end
