-- tests/run_cov.lua
pcall(require, "luarocks.loader")

local root = vim.fn.getcwd() -- repo root from shell
local luacov_runner = require("luacov.runner")

luacov_runner.init({
	statsfile = root .. "/luacov.stats.out",
	reportfile = root .. "/luacov.report.out",
})

-- ── run specs ────────────────────────────────
local harness = require("plenary.test_harness")
if type(harness.run) == "function" then
	harness.run()
else
	harness.test_directory("tests", {})
end
-- ─────────────────────────────────────────────

luacov_runner.shutdown() -- flush file
print(">> LuaCov stats at: " .. root .. "/luacov.stats.out")
vim.cmd("q")
