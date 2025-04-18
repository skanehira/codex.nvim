-- tests/run_cov.lua
pcall(require, "luarocks.loader") -- add ~/.luarocks/**/5.1 to package.path
require("luacov") -- start coverage

require("plenary.test_harness"):run() -- ← note the **colon**, not dot!

vim.cmd("q")
