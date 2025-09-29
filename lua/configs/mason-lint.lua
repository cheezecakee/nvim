local lint = package.loaded["lint"]

-- List of linters to ignore during install
local ignore_install = {}

-- Helper function to check if a value exists in a table
local function table_contains(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

-- Build a list of linters to install from the lint configuration
local linters_to_install = {}

for _, linter_list in pairs(lint.linters_by_ft) do
    for _, linter_name in ipairs(linter_list) do
        if not table_contains(ignore_install, linter_name) and
           not table_contains(linters_to_install, linter_name) then
            table.insert(linters_to_install, linter_name)
        end
    end
end

require("mason-nvim-lint").setup({
    ensure_installed = linters_to_install,
    automatic_installation = true,
})
