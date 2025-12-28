local vim = vim

vim.cmd('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.cmd('let &packpath = &runtimepath')
vim.cmd('source ~/.vimrc')

require('settings.plugins')

local ts_select = require("nvim-treesitter.incremental_selection")

vim.keymap.set("v", "<M-k>", ts_select.node_incremental, { silent = true })
vim.keymap.set("v", "<M-j>", ts_select.node_decremental, { silent = true })
vim.keymap.set('x', 'p', '"_dP', { noremap = true })

vim.keymap.set("v", "<leader>s", "<Esc>/\\%V", { silent = false })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "nix",
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 2
  end,
})
