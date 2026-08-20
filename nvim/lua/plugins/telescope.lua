return {
  'nvim-telescope/telescope.nvim', version = '*',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  opts = {
    defaults = {
      layout_strategy = 'vertical',
      layout_config = {width=0.9, height=0.95}
    }
  },
  keys = {
    {
      '<leader>tf',
      mode={'n'},
      function()
        require('telescope.builtin').find_files({
          layout_strategy='vertical',
          layout_config={width=0.9}
        })
      end
    },
    {
      '<leader>tc',
      mode={'n'},
      function() require('telescope.builtin').current_buffer_fuzzy_find() end
    },
    {
      '<leader>tg',
      mode={'n'},
      function() require('telescope.builtin').live_grep() end
    },
    {
      '<leader>tt',
      mode={'n'},
      function() require('telescope.builtin').treesitter() end
    },
    {
      '<leader>tr',
      mode={'n'},
      function() require('telescope.builtin').command_history() end
    },
    {
      '<leader>tb',
      mode={'n'},
      function() require('telescope.builtin').buffers() end
    },
  }
}

