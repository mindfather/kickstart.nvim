vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

require 'env'

require 'options'
require 'keymaps'
require 'autocommands'
require 'lazy-bootstrap'
require 'lazy-plugins'

-- NOTE: This is added at the end for Colemak support without messing with other existing bindings
vim.keymap.set('', 'n', 'j', { noremap = true })
vim.keymap.set('', 'N', 'J', { noremap = true })
vim.keymap.set('', 'e', 'k', { noremap = true })
vim.keymap.set('', 'E', 'K', { noremap = true })
vim.keymap.set('', 'i', 'l', { noremap = true })
vim.keymap.set('', 'I', 'L', { noremap = true })
vim.keymap.set('', 'k', 'n', { noremap = true })
vim.keymap.set('', 'K', 'N', { noremap = true })
vim.keymap.set('', 'u', 'i', { noremap = true })
vim.keymap.set('', 'U', 'I', { noremap = true })
vim.keymap.set('', 'l', 'u', { noremap = true })
vim.keymap.set('', 'L', 'U', { noremap = true })
vim.keymap.set('', 'f', 'e', { noremap = true })
vim.keymap.set('', 'F', 'E', { noremap = true })
vim.keymap.set('', 't', 'f', { noremap = true })
vim.keymap.set('', 'T', 'F', { noremap = true })
vim.keymap.set('', 'j', 't', { noremap = true })
vim.keymap.set('', 'J', 'T', { noremap = true })
