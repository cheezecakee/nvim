local twilight = require("twilight")
local map = vim.keymap.set

twilight.setup({
    dimming = {
        alpha = 0.25, -- how much to dim inactive portions
        color = { "Normal", "#ffffff" }, -- optional
        inactive = true, -- dim all windows except the current
    },
    context = 0, -- number of lines to keep fully visible around the cursor
    treesitter = true, -- use treesitter for code block detection
    expand = {}, -- patterns to expand
})

-- Keymap to toggle Twilight
map("n", "<F8>", "<cmd>Twilight<CR>", { desc = "Toggle Twilight" })
