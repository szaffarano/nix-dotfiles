local ok, mason, mason_lspconfig
ok, mason = pcall(require, "mason")
if not ok then
	print("mason plugin is not installed")
	return
end

ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not ok then
	print("mason-lspconfig plugin is not installed")
	return
end

local servers = {
	"sumneko_lua",
	"rust_analyzer",
	"pyright",
	"tsserver",
	"gopls",
	"grammarly",
	"jsonls",
	"bashls",
	"jsonls",
	"yamlls",
}

mason.setup({
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
})

mason_lspconfig.setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("sebas.lsp.handlers").on_attach,
		capabilities = require("sebas.lsp.handlers").capabilities,
	}

	local path = "sebas.lsp.settings." .. server
	local custom_settings
	ok, custom_settings = pcall(require, path)
	if ok then
		opts = vim.tbl_deep_extend("force", custom_settings, opts)
	end

	lspconfig[server].setup(opts)
end
