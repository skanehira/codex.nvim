-- tests/run_cov.lua
pcall(require, "luarocks.loader") -- add ~/.luarocks/**/5.1 to package.path

local runner = require("luacov.runner")
runner("start", {
	statsfile = "luacov.stats.out",
	reportfile = "luacov.report.out",
})

-- ── run all specs ───────────────────────────────────────────
local harness = require("plenary.test_harness")
if type(harness.run) == "function" then
	harness.run() -- older Plenary
else
	harness.test_directory("tests", {}) -- newer Plenary
end
-- ────────────────────────────────────────────────────────────

runner("stop") -- write luacov.stats.out
vim.cmd("q")
