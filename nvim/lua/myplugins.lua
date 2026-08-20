local M = {}

local function get_selected_content(exitVisualMode)
  local a = vim.fn.getpos('v')
  local b = vim.fn.getpos('.')
  local l1, l2 = a[2], b[2]
  local c1, c2 = a[3], b[3]
  if l1 > l2 then l1, l2 = l2, l1 end
  if c1 > c2 then c1, c2 = c2, c1 end

  local lines = vim.api.nvim_buf_get_text(a[1], l1 - 1, c1 - 1, l2 - 1, c2, {})
  text = table.concat(lines, "\n")

  -- exit visual mode
  local exitVisualMode = exitVisualMode or true
  if exitVisualMode then
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
      "n",
      false
    )
  end

  return text
end

function M.copy_file_path()
  local cs = vim.api.nvim_get_mode()
  local text = vim.fn.expand("%") 
  if cs.mode == "v" then
    text = get_selected_content()
  end
  pcall(vim.fn.setreg, "+", text)
  vim.fn.setreg('"', text)
end

function M.open_file_path()
  local text = get_selected_content()
  local buf = vim.fn.bufadd(text)
  vim.fn.bufload(buf)
  vim.bo[buf].buflisted = true

  local windows = vim.fn.getwininfo()
  for i = 1, #windows do
    if not string.match(vim.fn.bufname(vim.fn.winbufnr(windows[i].winid)), '#toggleterm#') then
      vim.api.nvim_win_set_buf(windows[i].winid, buf)
      vim.fn.win_gotoid(windows[i].winid)
      break
    end
  end
end

vim.keymap.set({'v', 'n'}, '<leader>pc', function() M.copy_file_path() end)
vim.keymap.set({'v'}, 'gf', function() M.open_file_path() end)
