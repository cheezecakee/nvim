-- configs/flutter-tools.lua

local flutter = require("flutter-tools")
local map = vim.keymap.set

flutter.setup({
    ui = {
        border = "rounded",
    },
    decorations = {
        statusline = {
            app_version = true,
            device = true,
        },
    },
    debugger = {
        enabled = false,
    },
    lsp = {
        on_attach = function(client, bufnr)
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            -- Keybindings for LSP actions
            map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", bufopts)
            map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", bufopts)
            map("n", "<F8>", "<cmd>lua vim.lsp.buf.code_action()<CR>", bufopts)

            -- Custom Flutter key mappings
            map("n", "<leader>fl", "<cmd>FlutterRun<CR>", bufopts)
            map("n", "<leader>fd", "<cmd>FlutterDevices<CR>", bufopts)
            map("n", "<leader>fs", "<cmd>FlutterRestart<CR>", bufopts)
            map("n", "<leader>fp", "<cmd>FlutterPubGet<CR>", bufopts)
        end,
        capabilities = require("nvchad.configs.lspconfig").capabilities,
    },
})
