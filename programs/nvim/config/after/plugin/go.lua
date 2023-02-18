local ok, go = pcall(require, "go")
if not ok then
	print("go-nvim plugin is not installed")
	return
end

go.setup()
