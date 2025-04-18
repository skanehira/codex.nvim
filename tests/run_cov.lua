-- tests/run_cov.lua
pcall(require, "luarocks.loader") -- LuaRocks paths (5.1)

local luacov_runner = require("luacov.runner")
luacov_runner.init() -- begin tracing *now*

-- ── run all specs ───────────────────────────────────────────
local harness = require("plenary.test_harness")
if type(harness.run) == "function" then
	harness.run() -- older Plenary
else
	harness.test_directory("tests", {}) -- newer Plenary
end
-- ────────────────────────────────────────────────────────────

luacov_runner.shutdown() -- flush luacov.stats.out
vim.cmd("q") -- quit Neovim
