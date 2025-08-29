-- tests/init.lua
-- luacheck: globals describe it before_each
-- luacheck: ignore async
local async = require 'plenary.async.tests'

describe('codex.nvim', function()
  -- No installer integration; ensure module loads cleanly

  it('should load without errors', function()
    require 'codex'
  end)

  it('should expose commands', function()
    require('codex').setup{}
    local cmds = vim.api.nvim_get_commands{}
    assert(cmds['Codex'] and cmds['CodexToggle'], 'Codex commands missing')
  end)
end)
