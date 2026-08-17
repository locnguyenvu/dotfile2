return {
  'akinsho/toggleterm.nvim',
  version = "*",
  lazy = false,
  config = true,
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 25
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    direction = "horizontal",
    start_in_insert = true,
    persist_mode = false
  },
  keys = {
    {'<F12>', '<cmd>:ToggleTerm<cr>' },
    {'<F12>', '<C-\\><C-N><cmd>:ToggleTerm<cr>', mode={'t'}},
    {'<C-W>', '<C-\\><C-N><C-W>', mode={'t'}},
    {'<C-,>', '<C-\\><C-N>', mode={'t'}},
  }
}
