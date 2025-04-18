-- tests/run_cov.lua
pcall(require, "luarocks.loader") -- LuaRocks paths (5.1)

require("luacov.runner")() -- ← starts the tracer immediately

-- run all specs (old or new Plenary API)
local harness = require("plenary.test_harness")
if type(harness.run) == "function" then
	harness.run()
else
	harness.test_directory("tests", {})
end

vim.cmd("q") -- quit headless nvim
