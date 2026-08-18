local M = {}

function M.copy_file_path(opts)
  local cs = vim.api.nvim_get_mode()
  local text = vim.fn.expand("%") 
  if cs.mode == "v" then
    local a = vim.fn.getpos('v')
    local b = vim.fn.getpos('.')
    local l1, l2 = a[2], b[2]
    local c1, c2 = a[3], b[3]
    if l1 > l2 then l1, l2 = l2, l1 end
    if c1 > c2 then c1, c2 = c2, c1 end

    local lines = vim.api.nvim_buf_get_text(a[1], l1 - 1, c1 - 1, l2 - 1, c2, {})
    text = table.concat(lines, "\n")

    -- exit visual mode
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
      "n",
      false
    )
  end
  pcall(vim.fn.setreg, "+", text)
  vim.fn.setreg('"', text)
  vim.notify(text)
end

vim.keymap.set({'v', 'n'}, '<leader>cp', function() M.copy_file_path({}) end)
