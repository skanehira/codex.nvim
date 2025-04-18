local vim = vim

local M = {}

local config = {
  keymaps = {},
  border = 'single',
  width = 0.8,
  height = 0.8,
}

local state = {
  buf = nil,
  win = nil,
  job = nil,
}

function M.setup(user_config)
  config = vim.tbl_deep_extend('force', config, user_config or {})
  vim.api.nvim_create_user_command('CodexToggle', function() M.toggle() end, {})
  if config.keymaps.toggle then
    vim.api.nvim_set_keymap('n', config.keymaps.toggle, '<cmd>CodexToggle<CR>', { noremap = true, silent = true })
  end
end

-- Create a floating window displaying the codex buffer
local function open_window()
  -- compute dimensions and position
  local width = math.floor(vim.o.columns * config.width)
  local height = math.floor(vim.o.lines * config.height)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  -- resolve border style (string or table)
  local border = config.border
  if type(border) == 'string' then
    local styles = {
      single = { {'╭','FloatBorder'},{'─','FloatBorder'},{'╮','FloatBorder'},{'│','FloatBorder'},{'╯','FloatBorder'},{'─','FloatBorder'},{'╰','FloatBorder'},{'│','FloatBorder'} },
      double = { {'╔','FloatBorder'},{'═','FloatBorder'},{'╗','FloatBorder'},{'║','FloatBorder'},{'╝','FloatBorder'},{'═','FloatBorder'},{'╚','FloatBorder'},{'║','FloatBorder'} },
      rounded = { {'╭','FloatBorder'},{'─','FloatBorder'},{'╮','FloatBorder'},{'│','FloatBorder'},{'╯','FloatBorder'},{'─','FloatBorder'},{'╰','FloatBorder'},{'│','FloatBorder'} },
      none = nil,
    }
    border = styles[border] or styles.single
  end
  -- open floating window
  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = border,
  })
end

function M.open()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_set_current_win(state.win)
    return
  end
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
    -- terminal buffer settings
    vim.api.nvim_buf_set_option(state.buf, 'buftype', 'terminal')
    vim.api.nvim_buf_set_option(state.buf, 'bufhidden', 'hide')
    vim.api.nvim_buf_set_option(state.buf, 'swapfile', false)
    vim.api.nvim_buf_set_option(state.buf, 'filetype', 'codex')
  end
  open_window()
  if not state.job then
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, {})
    state.job = vim.fn.termopen('codex', {
      cwd = vim.loop.cwd(),
      on_exit = function()
        state.job = nil
      end,
    })
  end
end

function M.close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
  end
end

function M.toggle()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    M.close()
  else
    M.open()
  end
end

function M.statusline()
  if state.job and not (state.win and vim.api.nvim_win_is_valid(state.win)) then
    return '[Codex]'
  end
  return ''
end

return M
