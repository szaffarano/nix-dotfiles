-- Enable Comment.nvim
local ok, comment = pcall(require, "Comment")
if not ok then
	print("Comment plugin is not installed")
	return
end

comment.setup()
