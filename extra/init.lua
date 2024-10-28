require("set")
require("remap")

DEFAULT_COLOR = "oh-lucy"
DEFAULT_BAR_COLOR = "none"

vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
  },
})

vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])
