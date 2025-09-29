local lint = require("lint")

-- Configure linters by filetype (only actual linters, not formatters)
lint.linters_by_ft = {
    lua = { "luacheck" },        -- Lua linter (stylua is a formatter, not linter)
    python = { "mypy", "ruff" }, -- Python type checker and linter
    svelte = { "eslint_d"}
}

-- Configure luacheck for Neovim development
lint.linters.luacheck.args = {
    "--globals",
    "love",
    "vim",
    "--formatter",
    "plain",
    "--codes",
    "--ranges",
    "-",
}

-- Create autocommands for automatic linting
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
        lint.try_lint()
    end,
})

-- Optional: Add command to manually trigger linting
vim.api.nvim_create_user_command("Lint", function()
    lint.try_lint()
end, { desc = "Run linter on current buffer" })
