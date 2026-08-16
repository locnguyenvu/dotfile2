return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = false },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = false },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
  end,
  keys = {
    {
      '<C-Enter>',
      function()
        local s = vim.fn.getpos("v")[2]
        local e = vim.fn.getpos(".")[2]
        vim.cmd(string.format("%d,%dDB", math.min(s, e), math.max(s, e)))
      end,
      mode = {'v'},
      desc = "Execute selected SQL with Dadbod",
    },
  }
}
