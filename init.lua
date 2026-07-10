require("vim._core.ui2").enable({})

local key = vim.keymap

vim.g.mapleader = " "
vim.g.maplocalleader = " "

key.set("n", "<leader>f", ":e<CR>")

require("options")
require("keymaps")
require("commands")
require("pack")
