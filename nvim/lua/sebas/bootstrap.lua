-- thanks TJ (tjdevries/config_manager)

local download_packer = function()
	local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	local packer_repo = "https://github.com/wbthomason/packer.nvim"

	local out = vim.fn.system(string.format("git clone %s %s", packer_repo, install_path))

	print(out)
	print("Downloading packer.nvim...")
	print("( You'll need to restart now )")
	vim.cmd([[packadd packer.nvim]])
end

return function()
	if not pcall(require, "packer") then
		download_packer()

		return true
	end

	return false
end
