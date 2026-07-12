--- mini cmdline completion ---
require("mini.cmdline").setup({
	autocorrect = { enable = false },
})

--- mini surround ---
require("mini.surround").setup()
-- Default Keymaps
-- | `sa` | Add surrounding or Direct with 'saiw' |
-- | `sd` | Delete surrounding |
-- | `sr` | Replace surrounding |
-- | `sf` | Find surrounding (right) |
-- | `sF` | Find surrounding (left) |
-- | `sh` | Highlight surrounding |
-- | `sn` | Update n_lines |
-- | `l` / `n` | as suffix for prev/next |

--- mini completion ---
local MiniCompletion = require("mini.completion")
MiniCompletion.setup({
	lsp_completion = {
		auto_setup = true,
	},
})

--- mini snippets ---
local MiniSnippets = require("mini.snippets")
MiniSnippets.setup({
	snippets = {
		MiniSnippets.gen_loader.from_lang(), -- loads friendly-snippets automatically
	},
	-- disable empty tabstop indicators
	expand = {
		insert = function(snippet)
			MiniSnippets.default_insert(snippet, { empty_tabstop = "" })
		end,
	},
})
MiniSnippets.start_lsp_server({ match = false })

local hl = vim.api.nvim_set_hl
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		hl(0, "MiniSnippetsCurrent", {})
		hl(0, "MiniSnippetsCurrentReplace", {})
		hl(0, "MiniSnippetsFinal", {})
		hl(0, "MiniSnippetsUnvisited", {})
		hl(0, "MiniSnippetsVisited", {})
	end,
})

--- mini clue ---

local MiniClue = require("mini.clue")

MiniClue.setup({
	triggers = {
		-- Leader triggers
		{ mode = { "n", "x" }, keys = "<Leader>" },

		-- `[` and `]` keys
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },

		-- Built-in completion
		{ mode = "i", keys = "<C-x>" },

		-- `g` key
		{ mode = { "n", "x" }, keys = "g" },

		-- Marks
		{ mode = { "n", "x" }, keys = "'" },
		{ mode = { "n", "x" }, keys = "`" },

		-- Registers
		{ mode = { "n", "x" }, keys = '"' },
		{ mode = { "i", "c" }, keys = "<C-r>" },

		-- Window commands
		{ mode = "n", keys = "<C-w>" },

		-- `z` key
		{ mode = { "n", "x" }, keys = "z" },
	},

	clues = {
		-- Enhance this by adding descriptions for <Leader> mapping groups
		MiniClue.gen_clues.square_brackets(),
		MiniClue.gen_clues.builtin_completion(),
		MiniClue.gen_clues.g(),
		MiniClue.gen_clues.marks(),
		MiniClue.gen_clues.registers(),
		MiniClue.gen_clues.windows(),
		MiniClue.gen_clues.z(),
	},
})

--- mini.hipatterns ---
local MiniHipatterns = require("mini.hipatterns")
MiniHipatterns.setup({
	highlighters = {
		-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

		-- Highlight hex color strings (`#rrggbb`) using that color
		hex_color = MiniHipatterns.gen_highlighter.hex_color(),
	},
})

--- mini ai ---
require("mini.ai").setup()

--- mini input ---
require("mini.input").setup()

--- mini bracketed ---
require("mini.bracketed").setup()

--- mini diff ---
require("mini.diff").setup()

--- mini splitjoin ---
require("mini.splitjoin").setup()

--- mini trailspace ---
require("mini.trailspace").setup()

--- mini pairs ---
require("mini.pairs").setup()

--- mini icons ---
require("mini.icons").setup()
