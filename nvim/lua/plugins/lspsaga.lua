return {
  "nvimdev/lspsaga.nvim",
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons',     -- optional
  },
  config = function()
    require('lspsaga').setup({
      lightbulb = {
        enable = false
      },
      breadcrumbs = {
        enable = true
      }
    })
  end,
  event = 'LspAttach',
  keys = {
    { '<leader>gd', '<cmd>Lspsaga peek_definition<cr>' },
    { '<leader>gD', '<cmd>Lspsaga goto_definition<cr>' },
    { '<leader>gt', '<cmd>Lspsaga peek_type_definition<cr>' },
    { '<leader>gT', '<cmd>Lspsaga goto_type_definition<cr>' },
    { '<leader>gf', '<cmd>Lspsaga finder<cr>' },
  }
}
