local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

-- list of all servers configured.
lspconfig.servers = {
    "lua_ls",
    "gopls",
    "clangd",
    "svelte",
    "ts_ls",
    "tailwindcss",
    "omnisharp"  -- Keep only omnisharp, it's better than csharp-language-server
}

-- list of servers configured with default config.
local default_servers = {
    "pyright",
    -- "hls",
}

-- lsps with default config
for _, lsp in ipairs(default_servers) do
    lspconfig[lsp].setup({
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
    })
end

lspconfig.gopls.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        on_attach(client, bufnr)
    end,
    on_init = on_init,
    capabilities = capabilities,
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gotmpl", "gowork" },
    root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            completeUnimported = true,
            usePlaceholders = true,
            staticcheck = true,
        },
    },
})

lspconfig.dartls.setup({
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    cmd = { "dart", "language-server" },
    filetypes = { "dart" },
    init_options = {
        onlyAnalyzeProjectsWithOpenFiles = false,
        suggestFromUnimportedLibraries = true,
        closingLabels = true,
        outline = true,
        flutterOutline = true,
    },
    settings = {
        dart = {
            completeFunctionCalls = true,
            showTodos = true,
            updateImportsOnRename = true,
        },
    },
})

lspconfig.clangd.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        on_attach(client, bufnr)
    end,
    on_init = on_init,
    capabilities = capabilities,
})

lspconfig.lua_ls.setup({
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    cmd = { "lua-language-server" },
    settings = {
        Lua = {
            diagnostics = {
                -- enable = false, -- Disable all diagnostics from lua_ls
                globals = { "vim" },
            },
            workspace = {
                library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                    vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                    vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                    "${3rd}/love2d/library",
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
})

lspconfig.ts_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig.tailwindcss.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig.svelte.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- C# Language Server (OmniSharp)
lspconfig.omnisharp.setup({
    on_attach = function(client, bufnr)
        -- Disable formatting since we'll use csharpier via conform
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        on_attach(client, bufnr)
    end,
    on_init = on_init,
    capabilities = capabilities,
    cmd = { "OmniSharp" }, -- Mason installs it as "OmniSharp"
    filetypes = { "cs" },
    root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", "omnisharp.json", "function.json"),
    settings = {
        FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = true,
        },
        RoslynExtensionsOptions = {
            EnableAnalyzersSupport = true,
            EnableImportCompletion = true,
            AnalyzeOpenDocumentsOnly = false,
        },
    },
})
