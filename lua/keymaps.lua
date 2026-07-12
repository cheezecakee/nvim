local key = vim.keymap

-- keymap selected text WITHOUT losing what you wanted
key.set("x", "p", [[_dp]], { desc = "Past over selection without losing yanked text" })

-- Delete text without saving it to any register
key.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

key.set("i", "<C-c>", "<Esc>")
key.set("n", "<C-c>", ":nohl<CR>", { desc = "Clear search highlighting", silent = true })

key.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Moves lines down in visual selection" })
key.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Moves lines up in visual selection" })

key.set("v", "<", "<gv", { desc = "Unindente and keep selection" })
key.set("v", ">", ">gv", { desc = "Indent and keep selection" })

key.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

key.set("n", "<C-d>", "<C-d>zz", { desc = "Move down in buffer with cursor centered" })
key.set("n", "<C-u>", "<C-u>zz", { desc = "Move up in buffer with cursor centered" })

key.set("n", "n", "nzzzv", { desc = "Next search result cursor centered" })
key.set("n", "N", "Nzzzv", { desc = "Previous search result cursor centered" })

key.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word cursor is on globally" }
)
key.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Makes file executable" })

key.set("n", "<leader>re", "<cmd>restart<cr>", { desc = "Restart config :restart)" })

key.set("n", ";", ":", { desc = "Enter command mode" })

-- native undotree
key.set("n", "<leader>u", function()
	vim.cmd.packadd("nvim.undotree")
	require("undotree").open()
end, { desc = "Toggle Builtin Undotree" })
