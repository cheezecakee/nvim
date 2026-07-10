vim.pack.add({
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/rafamadriz/friendly-snippets",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/rachartier/tiny-cmdline.nvim",
})

local key = vim.keymap

---- mini files ----
local MiniFiles = require("mini.files")

MiniFiles.setup({
    mappings = {
        go_in = "<CR>",
        go_in_plus = "L",
        go_out = "_",
        go_out_plus = "H",
    },
})

-- key.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })
--key.set("n", "<leader>-", function()
--    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
--    MiniFiles.reveal_cwd()
--end, { desc = "Toggle into currently opened file" })

--- mini notify ---
require("mini.notify").setup({
    -- only show messages
    content = {
        format = function(notif)
            return notif.msg
        end,
    },
})

--- mini cmdline completion --- 
require("mini.cmdline").setup({
    autocorrect = { enable = false }
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

--- mini picker ---
local MiniPick = require("mini.pick")
local MiniExtra = require("mini.extra")
MiniPick.setup()
MiniExtra.setup()

key.set("n", "<leader>pf", function() MiniPick.builtin.files() end, { desc = "Mini File Picker" })
key.set("n", "<leader>ps", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end, { desc = "Grep word/Search word" })
key.set("n", "<leader>vh", function() MiniPick.builtin.help() end, { desc = "Mini Help" })

key.set("n", "<leader>xx", function() MiniExtra.pickers.diagnostic() end, { desc = "Mini Picker"})
key.set("n", "<leader>pk", function() MiniExtra.pickers.keymaps() end, { desc = "Search keymaps" })

--- mini completion ---
local MiniCompletion = require("mini.completion")
MiniCompletion.setup({
    lsp_completion = {
        auto_setup = true,
    }
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

---- nvim treesitter ----
require("treesitter")

---- lsp ----
require("lsp")

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
