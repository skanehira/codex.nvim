-- tests/run_cov.lua
pcall(require, "luarocks.loader") -- make LuaRocks paths visible (5.1)
require("luacov") -- start coverage tracer

require("plenary.test_harness")() -- ← simply call the module

vim.cmd("q")
