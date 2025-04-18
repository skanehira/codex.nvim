-- Instrument LuaRocks paths (5.1)
pcall(require, "luarocks.loader")

-- Start LuaCov
local runner = require("luacov.runner")
runner.init({ -- you can add statsfile/reportfile here if desired
	statsfile = "luacov.stats.out",
	reportfile = "luacov.report.out",
})

-- ── Run all specs ───────────────────────────────────────────
local harness = require("plenary.test_harness")
if type(harness.run) == "function" then
	harness.run() -- Plenary ≤ 2023‑11
else
	harness.test_directory("tests", {}) -- Plenary ≥ 2023‑12
end
-- ────────────────────────────────────────────────────────────

runner.shutdown() -- force flush of luacov.stats.out
vim.cmd("q") -- quit Neovim
