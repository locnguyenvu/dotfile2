require('lualine').setup {
  sections = {
    lualine_b = {'diff', 'diagnostics'},
    lualine_c = {{'filename', path = 1}}
  },
  inactive_sections = {
    lualine_b = {'diff', 'diagnostics'},
    lualine_c = {{'filename', path = 1}}
  }
}

require('nvim-cursorline').setup {
  cursorline = {
    enable = true,
    timeout = 1000,
    number = false,
  },
  cursorword = {
    enable = true,
    min_length = 3,
    hl = { underline = true },
  }
}

vim.opt.termguicolors = true
require("bufferline").setup {}

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

-- Flash.nvim
vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end)
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end)
vim.keymap.set({'o'}, 'r', function() require('flash').remote() end)
vim.keymap.set({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end)
vim.keymap.set({ 'c' }, '<c-s>', function() require('flash').toggle() end)


-- Language server
require('lspsaga').setup({
  lightbulb = {
    enable = false
  },
  breadcrumbs = {
    enable = false
  }
})
vim.keymap.set({'n','t'}, '<F12>', '<cmd>Lspsaga term_toggle<CR>')

local cmp = require'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = 'nvim_lsp' },
  }
}

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>w', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local navbuddy = require('nvim-navbuddy')
navbuddy.setup{
  lsp = {
    auto_attach = true,
    preference = {'pylsp'}
  }
}
local on_attach = function(client, bufnr)
  -- navbuddy.attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', '<cmd>Lspsaga peek_definition<CR>', bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'gr', '<cmd>Lspsaga finder<CR>', bufopts)
end
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- NVIM LSP config
if vim.fn.executable('pylsp') == 1 then
  require'lspconfig'.pylsp.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            ignore = {'W391'},
            maxLineLength = 150
          },
        }
      }
    }
  }
end

if vim.fn.executable('ruff') == 1 then
  require'lspconfig'.ruff.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {
      settings = {
        -- Server settings should go here
        builtins = {"ic", "snoop", "pp"}
      }
  }
  }
end

