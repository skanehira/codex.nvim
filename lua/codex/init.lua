local vim = vim
local state = require 'codex.state'

local M = {}

local config = {
  keymaps = {
    toggle = nil,
    quit = '<C-q>', -- Default: Ctrl+q to quit
  },
  border = 'single',
  width = 0.8,
  height = 0.8,
  model = nil,  -- Default to the latest model
  winblend = 0, -- Transparency (0-100). Default: no blend.
  -- Window-local highlight mapping.
  -- Example to match normal buffer background:
  -- 'Normal:Normal,NormalFloat:Normal,TermNormal:Normal,TermNormalNC:Normal,FloatBorder:FloatBorder'
  winhl = 'Normal:Normal,NormalNC:NormalNC',
}

function M.setup(user_config)
  config = vim.tbl_deep_extend('force', config, user_config or {})

  vim.api.nvim_create_user_command('Codex', function()
    M.toggle()
  end, { desc = 'Toggle Codex popup' })

  vim.api.nvim_create_user_command('CodexToggle', function()
    M.toggle()
  end, { desc = 'Toggle Codex popup (alias)' })

  vim.api.nvim_create_user_command('CodexResume', function()
    M.resume()
  end, { desc = 'Resume Codex session' })

  if config.keymaps.toggle then
    vim.api.nvim_set_keymap('n', config.keymaps.toggle, '<cmd>CodexToggle<CR>', { noremap = true, silent = true })
  end
end

local function open_window()
  local width = math.floor(vim.o.columns * config.width)
  local height = math.floor(vim.o.lines * config.height)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local styles = {
    single = {
      { '┌', 'FloatBorder' },
      { '─', 'FloatBorder' },
      { '┐', 'FloatBorder' },
      { '│', 'FloatBorder' },
      { '┘', 'FloatBorder' },
      { '─', 'FloatBorder' },
      { '└', 'FloatBorder' },
      { '│', 'FloatBorder' },
    },
    double = {
      { '╔', 'FloatBorder' },
      { '═', 'FloatBorder' },
      { '╗', 'FloatBorder' },
      { '║', 'FloatBorder' },
      { '╝', 'FloatBorder' },
      { '═', 'FloatBorder' },
      { '╚', 'FloatBorder' },
      { '║', 'FloatBorder' },
    },
    rounded = {
      { '╭', 'FloatBorder' },
      { '─', 'FloatBorder' },
      { '╮', 'FloatBorder' },
      { '│', 'FloatBorder' },
      { '╯', 'FloatBorder' },
      { '─', 'FloatBorder' },
      { '╰', 'FloatBorder' },
      { '│', 'FloatBorder' },
    },
    none = nil,
  }

  local border = type(config.border) == 'string' and styles[config.border] or config.border

  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = border,
  })

  vim.api.nvim_set_option_value('winblend', config.winblend, { win = state.win })
  if type(config.winhl) == 'string' and #config.winhl > 0 then
    vim.api.nvim_set_option_value('winhl', config.winhl, { win = state.win })
  end
end

local function enter_terminal_insert()
  -- Ensure the float starts in terminal-insert mode when visible
  vim.schedule(function()
    if state.win and vim.api.nvim_win_is_valid(state.win) and state.buf and vim.api.nvim_buf_is_valid(state.buf) then
      local bt = vim.api.nvim_get_option_value('buftype', { buf = state.buf })
      if bt == 'terminal' then
        -- Focus the window and enter insert (terminal) mode
        vim.api.nvim_set_current_win(state.win)
        vim.cmd 'startinsert'
      end
    end
  end)
end

local function create_clean_buf()
  local buf = vim.api.nvim_create_buf(false, false)

  vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = buf })
  vim.api.nvim_set_option_value('swapfile', false, { buf = buf })
  vim.api.nvim_set_option_value('filetype', 'codex', { buf = buf })

  -- Apply configured quit keybinding

  if config.keymaps.quit then
    local quit_cmd = [[<cmd>lua require('codex').close()<CR>]]
    vim.api.nvim_buf_set_keymap(buf, 't', config.keymaps.quit, [[<C-\><C-n>]] .. quit_cmd,
      { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', config.keymaps.quit, quit_cmd, { noremap = true, silent = true })
  end

  return buf
end

local function is_buf_reusable(buf)
  return type(buf) == 'number' and vim.api.nvim_buf_is_valid(buf)
end

local function open_codex_with_command(cmd_args)
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_set_current_win(state.win)
    return
  end

  if vim.fn.executable('codex') == 0 then
    if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
      state.buf = create_clean_buf()
    end
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, {
      'Codex CLI not found.',
      '',
      'Install with:',
      '  npm install -g @openai/codex',
    })
    open_window()
    return
  end

  if not is_buf_reusable(state.buf) then
    state.buf = create_clean_buf()
  end

  open_window()
  enter_terminal_insert()

  if not state.job then
    if config.model then
      table.insert(cmd_args, '-m')
      table.insert(cmd_args, config.model)
    end

    state.job = vim.fn.termopen(cmd_args, {
      cwd = vim.loop.cwd(),
      on_exit = function()
        state.job = nil
      end,
    })
    enter_terminal_insert()
  end
end

function M.open()
  open_codex_with_command({ 'codex' })
end

function M.close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
end

function M.toggle()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    M.close()
  else
    M.open()
  end
end

function M.resume()
  open_codex_with_command({ 'codex', 'resume' })
end

function M.statusline()
  if state.job and not (state.win and vim.api.nvim_win_is_valid(state.win)) then
    return '[Codex]'
  end
  return ''
end

function M.status()
  return {
    function()
      return M.statusline()
    end,
    cond = function()
      return M.statusline() ~= ''
    end,
    icon = '',
    color = { fg = '#51afef' },
  }
end

return setmetatable(M, {
  __call = function(_, opts)
    M.setup(opts)
    return M
  end,
})
