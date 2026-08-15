---@type LazySpec
return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = {'nvim-tree/nvim-web-devicons'},
  event = "VeryLazy",
  opts = {
    options = {
      numbers = "buffer_id"
    }
  },
  keys = {
    { '<leader>l', '<cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
    {  '<leader>L', '<cmd>BufferLineMoveNext<CR>', desc = 'Move buffer next' },
    {  '<leader>h', '<cmd>BufferLineCyclePrev<CR>', desc = 'Previous buffer' },
    {  '<leader>H', '<cmd>BufferLineMovePrev<CR>', desc = 'Move buffer prev' },
    {  '<leader>e', '<cmd>BufferLinePick<CR>', desc = 'Pick buffer' },
    {  '<leader>d', '<cmd>BufferLinePickClose<CR>', desc = 'Pick close buffer' },
    {  '<leader>bo', '<cmd>BufferLineCloseOthers<CR>', desc = 'Close other buffers' },
    {  '<leader>br', '<cmd>BufferLineCloseRight<CR>', desc = 'Close buffers right' },
    {  '<leader>bl', '<cmd>BufferLineCloseLeft<CR>', desc = 'Close buffers left' },
    {  '<leader>bp', '<cmd>BufferLineTogglePin<CR>', desc = 'Toggle pin buffer' },
    {  '<leader>b1', '<cmd>BufferLineGoToBuffer 1<CR>', desc = 'Go to buffer 1' },
  },
}
