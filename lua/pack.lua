vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/rafamadriz/friendly-snippets",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/rachartier/tiny-cmdline.nvim",
	"https://github.com/mfussenegger/nvim-lint",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/folke/snacks.nvim",
})

local key = vim.keymap

---- oil ----
require("oil").setup({
	default_file_explorer = true,
	columns = {
		"icon",
		-- "permissions",
		-- "size",
		-- "mtime",
	},
	-- Buffer-local options to use for oil buffers
	buf_options = {
		buflisted = false,
		bufhidden = "hide",
	},
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
})
key.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
key.set("n", "<leader>-", require("oil").toggle_float)

---- mini ----
require("mini")

---- snacks ----
require("snack")

---- nvim treesitter ----
require("treesitter")

---- lsp ----
require("lsp")

-- lint ---
require("linter")

--- formatter ---
require("formatter")

---- mason ----
require("mason").setup()
