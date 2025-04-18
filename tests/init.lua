-- tests/init.lua
local async = require("plenary.async.tests")

describe("codex.nvim", function()
	it("should load without errors", function()
		require("codex")
	end)

	it("should respond to basic command", function()
		vim.cmd("CodexHello")
		-- Add assertion if it triggers some output or state change
	end)
end)
