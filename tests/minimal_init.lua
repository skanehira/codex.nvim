pcall(require, "luacov.runner").init()
vim.cmd("set rtp+=.")
vim.cmd("set rtp+=./plenary.nvim") -- if using as a submodule or symlinked
require("plugin.codex") -- triggers plugin/codex.lua
