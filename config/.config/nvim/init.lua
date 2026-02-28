-- Redirect to config/init.lua with error handling
local ok, err = pcall(require, "config.init")
if not ok then
	vim.notify("Error loading config: " .. tostring(err), vim.log.levels.ERROR)
	print("Error loading config: " .. tostring(err))
	error(err)
end
