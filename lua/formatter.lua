local key = vim.keymap
local conform = require("conform")

local options = {
    formatters = {
        ["markdown-toc"] = {
            condition = function (_, ctx)
                for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
                    if line:find("<!%-%- toc %-%->") then
                        return true
                    end
                end
            end,
        },
        ["markdownlint-cli2"] = {
            condition = function (_, ctx)
                local diag = vim.tbl_filter(function(d)
                    return d.source == "markdownlint"
                end, vim.diagnostic.get(ctx.buf))
                return #diag > 0
            end,
        },
        ["clang-format"] = {
            prepend_args = {
                "-style={ \
                indentWidth: 4, \
                TabWidth: 4, \
                UseTab: Never, \
                AccessModifierOffset: 0, \
                indentAccessModifiers: true, \
                PackConstructorInitializers: Never}",
            },
        },
        prettier = {
            args = {
				"--stdin-filepath",
				"$FILENAME",
				"--tab-width",
				"4",
				"--use-tabs",
				"false",
			},
        },
        black = {
            prepend_args = {
                "--fast",
            },
        },
        shfmt = {
			prepend_args = { "-i", "4" },
        },
    },
    formatters_by_ft = {
        bash = { "shfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        css = { "biome-check" },
        go = { "goimports", "gofumpt"},
        html = { "prettier" },
        javascript = { "biome-check" },
        javascriptreact = { "biome-check" },
        json = { "biome-check" },
        lua = { "stylua" },
        markdown = { "mdformat","markdownlint-cli2","markdown-toc" },
        nix = { "nixfmt" },
        python = { "black" },
        sh = { "shfmt" },
        svelte = { "prettier" },
        typescript = { "biome-check" },
        typescriptreact = { "biome-check" },
        yaml = { "prettier" },
    },
    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = "fallback",
    },
    notify_on_error = true,
    notify_no_formatters = true,
}

conform.setup(options)

key.set({ "n", "v" }, "<leader>fp", function()
    conform.format({
        lsp_format = "fallback",
        async = false,
        timeout_ms = 500,
    })
end, { desc = "Format whole file or range in visual mode" })
