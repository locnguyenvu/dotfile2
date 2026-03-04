-- Copy current buffer file name + selected line range to clipboard and tmux buffer.
-- Usage (in init.lua):
--   dofile(vim.fn.expand('~/Download/file_info_extract.lua'))
-- or:
--   local mod = dofile(vim.fn.expand('~/Download/file_info_extract.lua'))
--   vim.keymap.set('x', '<leader>cp', mod.copy_range)

local M = {}

function M.copy_view_context(opts)
  opts = opts or {}
  local buf = 0

  local file = vim.api.nvim_buf_get_name(buf)
  if file == "" then file = "[No Name]" end
  file = vim.fn.fnamemodify(file, ":.")

  local a = vim.fn.getpos("'<")
  local b = vim.fn.getpos("'>")
  local l1, l2 = a[2], b[2]
  if l1 > l2 then l1, l2 = l2, l1 end

  local header = string.format("%s:%d-%d", file, l1, l2)
  local text = header

  if opts.include_text then
    local lines = vim.api.nvim_buf_get_lines(buf, l1 - 1, l2, false)
    text = header .. "\n" .. table.concat(lines, "\n")
  end

  -- System clipboard (if available)
  pcall(vim.fn.setreg, "+", text)
  vim.fn.setreg('"', text)

  -- tmux buffer (so you can paste via tmux even without system clipboard)
  if vim.env.TMUX and vim.fn.executable("tmux") == 1 then
    pcall(vim.fn.system, { "tmux", "load-buffer", "-" }, text)
  end
  -- Exit visual mode if called from visual mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

function M.copy_range()
  return M.copy_view_context({ include_text = false })
end

function M.copy_range_with_text()
  return M.copy_view_context({ include_text = true })
end

function M.get_relative_path()
  local buf = 0
  local file = vim.api.nvim_buf_get_name(buf)
  if file == "" then file = "[No Name]" end
  local path = vim.fn.fnamemodify(file, ":.")
  
  -- System clipboard (if available)
  pcall(vim.fn.setreg, "+", path)
  vim.fn.setreg('"', path)
  
  -- tmux buffer (so you can paste via tmux even without system clipboard)
  if vim.env.TMUX and vim.fn.executable("tmux") == 1 then
    pcall(vim.fn.system, { "tmux", "load-buffer", "-" }, path)
  end
  
  return path
end

return M
