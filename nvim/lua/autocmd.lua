vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "zsh", "sh", "nix", "vue", "json", "typescript", "typescript.tsx", "lua", "toml" },
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


