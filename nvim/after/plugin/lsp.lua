local lsp = require('lsp-zero')
lsp.preset("recommended")

lsp.ensure_installed({
	'tsserver',
	'rust_analyzer',
})

lsp.nvim_workspace()

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<Tab>'] = cmp.mapping.select_next_item(cmp_select),
  ['<Enter>'] = cmp.mapping.confirm({ select = true }),
})

lsp.setup_nvim_cmp({
	mapping = cmp_mappings
})


lsp.set_preferences({
	suggest_lsp_servers = true
})

local navic = require('nvim-navic')

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

vim.diagnostic.config({
	virtual_text = true
})

