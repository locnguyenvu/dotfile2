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
vim.g.clipboard = 'osc52'

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "sh", "nix", "vue", "json", "typescript", "typescript.tsx", "lua", "toml" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby", "python" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

require("config.lazy")

if vim.fn.executable('ruby-lsp') == 1 then
  vim.lsp.enable('ruby_lsp')
end

