-- vim: ts=2 sw=2 autoindent expandtab foldmethod=marker

--- provider {{{
local is_ssh = vim.env.SSH_CONNECTION ~= nil or vim.env.SSH_CLIENT ~= nil
if is_ssh then
  vim.g.clipboard = 'osc52'
end
--- }}}

-- Theme cappuccin {{{{{
require("catppuccin").setup({
  flavour = "frappe", -- latte, frappe, macchiato, mocha
  background = { -- :h background
    light = "latte",
    dark = "frappe",
  },
  term_colors = true,
})
-- }}}}}}

-- lualine {{{
require('lualine').setup {
  sections = {
    lualine_b = {{'lsp_status'}},
    lualine_c = {{'filename', path = 1}}
  },
  inactive_sections = {
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {{'filename', path = 1}}
  }
}
-- }}}

-- nvim-cursorline {{{
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
-- }}}

-- bufferline {{{
vim.opt.termguicolors = true
require("bufferline").setup {
  options = {
    groups = { 
      items = {
        {
          name = "empty", -- Mandatory
          highlight = {underline = true, sp = "blue"}, -- Optional
          icon = " ", -- Optional
          matcher = function(buf) -- Mandatory
            return buf.name:match('leftpad') or buf.name:match('rightpad')
          end
        }
      }
    },
    offsets = {
      filetype = "NvimTree",
      text = "File Explorer",
      highlight = "Directory",
      separator = true -- use a "true" to enable the default, or set your own character
    }
  }
}
-- }}}

-- nvim-tree {{{
require("nvim-tree").setup {
  auto_reload_on_write = false,
  view = {
    relativenumber = true, 
    width = 35,
    float = {
      enable = true,
      quit_on_focus_loss = true,
      open_win_config = {
        width = 50
      }
    }
  },
  filters = {
    custom = { '__pycache__', '*.egg-info', 'node_modules', '.venv' },
    exclude = {},
  },
  git = {
    ignore = true,
  }
}
-- }}}

-- Treesitter {{{
-- Highlight
vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function() vim.treesitter.start() end,
})
-- Folds
-- vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- vim.wo[0][0].foldmethod = 'expr'
-- Indention
-- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
-- }}}

-- Telescope {{{
require('telescope').setup({
  defaults = {
    layout_config = {
      vertical = { width = 0.95 }
    },
    mappings = {
      i = {
        ['<C-p>'] = require('telescope.actions.layout').toggle_preview
      }
    },
    preview = {
      hide_on_startup = true
    },
  },
})
-- }}}

-- Flash.nvim {{{
vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end)
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end)
vim.keymap.set({'o'}, 'r', function() require('flash').remote() end)
vim.keymap.set({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end)
vim.keymap.set({ 'c' }, '<c-s>', function() require('flash').toggle() end)
-- }}}

-- Kitty-scrollback
require('kitty-scrollback').setup()

-- toggle term {{{
require('toggleterm').setup({
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
})
-- }}}

-- Nvim LSP config
---- navbuddy {{{
local navbuddy = require('nvim-navbuddy')
navbuddy.setup{
  window = {
    size = { height = '80%', width = '70%' },
  },
  lsp = {
    auto_attach = true,
    preference = {'pylsp'}
  }
}
-- }}}
---- Lspsaga {{{
require('lspsaga').setup({
  lightbulb = {
    enable = false
  },
  breadcrumbs = {
    enable = true
  }
})
-- }}}
---- CMP {{{
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
-- }}}
---- keymap {{{
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>w', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
})
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if client.supports_method and client:supports_method("textDocument/documentSymbol") then
      navbuddy.attach(client, args.buf)
    end
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(args.buf, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local bufopts = { noremap=true, silent=true, buffer=args.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gi', '<cmd>Lspsaga finder imp<CR>', bufopts)
    vim.keymap.set('n', 'gr', '<cmd>Lspsaga finder ref<CR>', bufopts)
    vim.keymap.set('n', 'K', '<cmd>Lspsaga peek_definition<CR>', bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', '<cmd>Lspsaga peek_type_definition<CR>', bufopts)
    vim.keymap.set('n', '<space>rn', '<cmd>Lspsaga rename<CR>', bufopts)
    vim.keymap.set('n', '<space>ca', '<cmd>Lspsaga code_action<CR>', bufopts)
  end
})
--- }}}
-- LSP Python {{{
---- pylsp {{{
if vim.fn.executable('pylsp') == 1 then
  vim.lsp.config('pylsp', {
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
  })
  vim.lsp.enable('pylsp')
end
-- }}}
---- ruff {{{
if vim.fn.executable('ruff') == 1 then
  vim.lsp.config('ruff', {
    capabilities = vim.tbl_deep_extend(
      'force',
      require('cmp_nvim_lsp').default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      ),
      { general = { positionEncodings = { 'utf-16' } } }
    ),
    init_options = {
      settings = {
        -- Server settings should go here
        builtins = {"ic", "snoop", "pp"}
      }
    }
  })
  vim.lsp.enable('ruff')
end
-- }}}
-- }}}
-- LSP Go {{{
----- gopls {{{
if vim.fn.executable('go') == 1 then
  vim.lsp.enable('go')
end
if vim.fn.executable('gopls') == 1 then
  vim.lsp.enable('gopls')
end
-- }}}
---- auto lint {{{
if vim.fn.executable('goimports') == 1 then
  local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
     require('go.format').goimports()
    end,
    group = format_sync_grp,
  })
end
-- }}}
-- }}}
--- LSP ruby {{{
if vim.fn.executable('ruby-lsp') == 1 then
  vim.lsp.enable('ruby_lsp')
end
-- }}}

-- Custom display
---- folding {{{
local middot = '·'
local raquo = '»'
local small_l = 'ℓ'
_G.foldtext = function()
  local line_count = vim.v.foldend - vim.v.foldstart + 1
  local lines = '[' .. line_count .. small_l .. ']'
  local first = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, true)[1]
  local tabs = first:match('^%s*'):gsub(' +', ''):len()
  local spaces = first:match('^%s*'):gsub('\t', ''):len()
  local indent = spaces + tabs * vim.bo.tabstop
  local stripped = first:match('^%s*(.-)$')
  local prefix = raquo .. middot .. middot .. lines
  local suffix = ': '

  -- Can't usefully use string.len() on UTF-8.
  local prefix_len = tostring(line_count):len() + 6

  local dash_count = math.max(indent - prefix_len - string.len(suffix), 0)
  local dashes = string.rep(middot, dash_count)
  return prefix .. dashes .. suffix .. stripped
end

vim.opt.foldtext = 'v:lua.foldtext()'
-- }}}
---- indent {{{
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
-- }}}

-- Git
-- Fugitive {{{
-- fetch and merge current active branch only
vim.api.nvim_create_user_command('Gfm', function()
  local handle = io.popen("git branch --show-current")
  local current_branch = handle:read("*a"):gsub("%s+", "")
  handle:close()
  if current_branch == "" then
    vim.notify("Error: Could not determine current branch", vim.log.levels.ERROR)
    return
  end
  local git_cmd = string.format("Git pull origin %s", current_branch)
  vim.cmd(git_cmd)
end, {
  desc = 'Git fetch and merge current branch from origin'
})
-- }}}

-- Plugin
-- Open file {{{

local Lzof = {}

function Lzof.open_file(path, close_terminal)
  local function parse_path_with_position(path_string)
    local p, line, col = path_string:match("^(.+):(%d+)(?::(%d+))?$")
    if p then
      return p, tonumber(line), tonumber(col)
    end
    return path_string, nil, nil
  end

  local function file_exists(file_path)
    local stat = vim.loop.fs_stat(file_path)
    return stat ~= nil
  end

  local line, col = nil, nil
  path, line, col = parse_path_with_position(path)

  if not file_exists(path) then
    vim.notify(string.format("File not found: %s", path), vim.log.levels.WARN)
    return
  end

  local escaped_path = vim.fn.fnameescape(path)

  -- Check if current window is a terminal
  local current_bufnr = vim.api.nvim_get_current_buf()
  local current_buftype = vim.api.nvim_buf_get_option(current_bufnr, "buftype")

  if current_buftype == "terminal" then
    if close_terminal and #vim.api.nvim_list_wins() > 1 then
      vim.api.nvim_win_close(vim.api.nvim_get_current_win(), false)
    end
    local windows = vim.api.nvim_list_wins()

    for _, winid in ipairs(windows) do
      local bufnr = vim.api.nvim_win_get_buf(winid)
      local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")

      if buftype ~= "terminal" then
        vim.api.nvim_set_current_win(winid)
        break
      end
    end
  end

  vim.cmd(string.format("edit %s", escaped_path))

  if line then
    vim.api.nvim_win_set_cursor(0, { line, col or 0 })
  end
end

function Lzof.open_path_from_selection(close_terminal)
  local function get_visual_selection()
    local _, srow, scol = unpack(vim.fn.getpos("'<"))
    local _, erow, ecol = unpack(vim.fn.getpos("'>"))

    if srow == erow then
      local line = vim.fn.getline(srow)
      return line:sub(scol, ecol)
    end

    local lines = vim.fn.getline(srow, erow)
    lines[1] = lines[1]:sub(scol)
    lines[#lines] = lines[#lines]:sub(1, ecol)
    return table.concat(lines, "\n")
  end

  local function resolve_path(file_path)
    if file_path:sub(1, 1) == "~" then
      return vim.fn.expand(file_path)
    end

    if file_path:sub(1, 1) == "/" then
      return file_path
    end

    local cwd = vim.fn.getcwd()
    return cwd .. "/" .. file_path
  end

  local selected_text = get_visual_selection()

  if not selected_text or selected_text == "" then
    vim.notify("No text selected", vim.log.levels.WARN)
    return
  end

  local path = vim.fn.trim(selected_text):gsub("\n", "")
  local resolved_path = resolve_path(path)
  Lzof.open_file(resolved_path, close_terminal)
end

function Lzof.setup(opts)
  opts = opts or {
    keymaps = true
  }
  vim.api.nvim_create_user_command("LFOpenPath", function(args)
    local close_terminal = args.bang
    Lzof.open_path_from_selection(close_terminal)
  end, { range = true, bang = true, desc = "Open file path from visual selection" })

  if opts.keymaps ~= false then
    vim.keymap.set('v', 'gf', ':LFOpenPath!<CR>', { silent = true })
  end
end
Lzof.setup({keymaps = true})
-- }}}


local file_info_extract = dofile(vim.fn.expand('~/.dotfile/nvim/file_info_extract.lua'))
vim.keymap.set('n', '<leader>cp', function() file_info_extract.get_relative_path() end)
vim.keymap.set('x', '<leader>cp', function() file_info_extract.copy_range() end)
vim.keymap.set("x", "<leader>cP", function() file_info_extract.copy_range_with_text() end)
