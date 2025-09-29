local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        go = { "gofumpt", "goimports-reviser" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        python = { "black" },
        dart = { "dart_format", "dcm_format" },
        haskell = { "hindent" },
        javascript = { "biome" },
        javascriptreact = { "biome" },
        typescript = { "biome" },
        typescriptreact = { "biome" },
        json = { "biome" },
        jsonc = { "biome" },
        svelte = { "prettier" },
        cs = { "csharpier" },
    },

    formatters = {
        -- ["goimports-reviser"] = {
        --     prepend_args = { "-rm-unused" },
        -- },
        -- golines = {
        --     prepend_args = { "--max-len=80" },
        -- },
        -- Lua
        stylua = {
            command = "stylua", -- Use system binary
        },
        ["clang-format"] = {
            prepend_args = {
                "-style={ \
                IndentWidth: 4, \
                TabWidth: 4, \
                UseTab: Never, \
                AccessModifierOffset: 0, \
                IndentAccessModifiers: true, \
                PackConstructorInitializers: Never}",
            },
        },
        -- Python
        black = {
            prepend_args = {
                "--fast",
            },
        },
        -- C#
        ["csharpier"] = {
            args = { "format", "--two-stdin" },
        },
    },

    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 1000,
        lsp_fallback = true,
    },
}

require("conform").setup(options)
