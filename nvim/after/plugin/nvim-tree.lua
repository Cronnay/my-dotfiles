local api = require('nvim-tree.api')
local function my_on_attach(bufnr)
    api.config.mappings.default_on_attach(bufnr)
end

require('nvim-tree').setup {
    on_attach = my_on_attach
}

vim.keymap.set("n", '<leader>e', api.tree.toggle)
