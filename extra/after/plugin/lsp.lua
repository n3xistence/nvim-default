-- LSP Zero
local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  --	vim.keymap.set("n", "<leader>vd", function() vim.diagnostics,open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostics.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostics.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

-- LSP Servers
local lspconfig = require("lspconfig")

lspconfig.pyright.setup({})
lspconfig.lua_ls.setup({})
lspconfig.nil_ls.setup({})
lspconfig.marksman.setup({})
lspconfig.rust_analyzer.setup({})
lspconfig.ts_ls.setup({})
-- lspconfig.biome_lsp.setup({})
lspconfig.yamlls.setup({})
lspconfig.bashls.setup({})
lspconfig.clangd.setup({
  cmd = { "clangd", "--offset-encoding=utf-16" }, -- Custom command for clangd
})
lspconfig.emmet_language_server.setup({})
