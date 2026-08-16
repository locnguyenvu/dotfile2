-- Global defaults
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

local is_ssh = vim.env.SSH_CONNECTION ~= nil or vim.env.SSH_CLIENT ~= nil
if is_ssh then
  vim.g.clipboard = 'osc52'
end

require("config.lazy")
require("lspconfig")
require("autocmd")

