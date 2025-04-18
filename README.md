# Codex Neovim Plugin

A Neovim plugin integrating the open-sourced Codex CLI (`codex`).

Features:
- Toggle Codex floating window with `:CodexToggle`
- Optional keymap mapping via `setup` call
- Background running when window hidden
- Statusline integration via `require('codex').statusline()`

Installation:
Use your plugin manager, e.g., with packer.nvim:
```lua
use {
  'johnseth97/codex.nvim',
  config = function()
    require('codex').setup {
      keymaps = { toggle = '<leader>cc' },
      border = 'double',
      width = 0.7,
      height = 0.7,
    }
  end,
}
```

Usage:
- Call `:Codex` (or `:CodexToggle`) to open or close the Codex popup.
-- Map your own keybindings via the `keymaps.toggle` setting.
- Add to your statusline:
```vim
set statusline+=%{v:lua.require'codex'.statusline()}
```
