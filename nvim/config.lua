require("lualine").setup {}

require("bufferline").setup {
  options = {
    indicator = {
      icon = '▎'
    },
    modified_icon = '●',
    left_trunc_marker = '',
    right_trunc_marker = '',
    diagnostics = 'nvim_lsp',
    show_close_icon = false,
    show_buffer_close_icons = false,
    offsets = {{filetype = "NvimTree", text = "File Explorer"}},
    middle_mouse_command = "bdelete! %d",
  }
}

require("nvim-tree").setup {
  auto_reload_on_write = false,
  view = {
    relativenumber = true, 
    width = 40,
  },
  filters = {
    custom = { '__pycache__', '*.egg-info', 'node_modules', '.venv' },
  exclude = {},
  },
  git = {
    ignore = true,
  }
}

-- Indent blank-line
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"
local ibl_highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}
local hooks = require "ibl.hooks"
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

require("ibl").setup { indent = { highlight = ibl_highlight } }

-- Treesitter
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
}
