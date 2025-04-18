-- tests/run_cov.lua
pcall(require, "luarocks.loader") -- add LuaRocks 5.1 paths
require("luacov") -- start coverage tracer

local harness = require("plenary.test_harness")

if type(harness.run) == "function" then
	harness.run() -- old API
elseif type(harness.test_directory) == "function" then
	harness.test_directory("tests", {}) -- new API
else
	error("Unknown plenary.test_harness API")
end

vim.cmd("q") -- quit Neovim headless
