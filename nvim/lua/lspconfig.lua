---- ruby {{{
if vim.fn.executable('ruby-lsp') == 1 then
  vim.lsp.enable('ruby_lsp')
end
-- }}

---- {{ python-lsp-server
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
  vim.lsp.enable('ruff')
end
-- }}

---- vue_ls {{{
if vim.fn.executable('vue-language-server') == 1 then
  vim.lsp.enable('vue_ls')
end
