# Codex Neovim Plugin
<img width="1480" alt="image" src="https://github.com/user-attachments/assets/eac126c5-e71c-4de9-817a-bf4e8f2f6af9" />

## A Neovim plugin integrating the open-sourced Codex CLI (`codex`)
> Latest version: ![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/johnseth97/codex.nvim?sort=semver)

### Features:
- ✅ Toggle Codex floating window with `:CodexToggle`
- ✅ Optional keymap mapping via `setup` call
- ✅ Background running when window hidden
- ✅ Statusline integration via `require('codex').status()`

### Installation:

- Install the `codex` CLI via npm, or mark autoinstall as true in the config function

```bash
npm install -g @openai/codex
```

- Grab an API key from OpenAI and set it in your environment variables:
  - Note: You can also set it in your `~/.bashrc` or `~/.zshrc` file to persist across sessions, but be careful with security. Especially if you share your config files.

```bash
export OPENAI_API_KEY=your_api_key
```

- Use your plugin manager, e.g. lazy.nvim:

```lua
return {
  'johnseth97/codex.nvim',
  lazy = true,
  cmd = { 'Codex', 'CodexToggle' }, -- Optional: Load only on command execution
  keys = {
    {
      '<leader>cc', -- Change this to your preferred keybinding
      function() require('codex').toggle() end,
      desc = 'Toggle Codex popup',
    },
  },
  opts = {
    keymaps     = {
      toggle = nil, -- Keybind to toggle Codex window (Disabled by default, watch out for conflicts)
      quit = '<C-q>', -- Keybind to close the Codex window (default: Ctrl + q)
    },         -- Disable internal default keymap (<leader>cc -> :CodexToggle)
    border      = 'rounded',  -- Options: 'single', 'double', or 'rounded'
    width       = 0.8,        -- Width of the floating window (0.0 to 1.0)
    height      = 0.8,        -- Height of the floating window (0.0 to 1.0)
    model       = nil,        -- Optional: pass a string to use a specific model (e.g., 'o3-mini')
    autoinstall = true,       -- Automatically install the Codex CLI if not found
  },
}```

### Usage:
- Call `:Codex` (or `:CodexToggle`) to open or close the Codex popup.
-- Map your own keybindings via the `keymaps.toggle` setting.
- Add the following code to show backgrounded Codex window in lualine:

```lua
require('codex').status() -- drop in to your lualine sections
```

### Configuration:
- All plugin configurations can be seen in the `opts` table of the plugin setup, as shown in the installation section.

- **For deeper customization, please refer to the [Codex CLI documentation](https://github.com/openai/codex?tab=readme-ov-file#full-configuration-example) full configuration example. These features change quickly as Codex CLI is in active beta development.*

#### Float Window Appearance
- Defaults aim to match normal buffers:
  - `winblend = 0`
  - `winhl = 'Normal:Normal,NormalFloat:Normal,NormalNC:NormalNC'`
- You can override in setup, e.g. subtle blend and border keep:

```lua
require('codex').setup({
  winblend = 10,
  winhl = 'Normal:Normal,NormalFloat:Normal,NormalNC:NormalNC,FloatBorder:FloatBorder',
})
```
