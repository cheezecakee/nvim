local key = vim.keymap

---- snacks picker ----
local Snacks = require("snacks")

Snacks.setup({
	scroll = {},
	lazygit = {},
	gh = {},
	indent = {},
	dim = {},
	scope = {},
	toggle = {},
	terminal = {},
	notifier = {
		enabled = true,
		style = "minimal",
	},
	picker = {
		enabled = true,
		matchers = {
			frecency = true,
			cwd_bonus = false,
		},
		exclude = {
			".git",
			"node_modules",
			"dist",
			"build",
		},
		sources = {
			gh_issue = {
				-- your gh_issue picker configuration comes here
				-- or leave it empty to use the default settings
			},
			gh_pr = {
				-- your gh_pr picker configuration comes here
				-- or leave it empty to use the default settings
			},
		},
		formatters = {
			file = {
				filename_first = true,
				filename_only = false,
				icon_width = 2,
			},
		},
		layout = {
			-- presets options : "default" , "ivy" , "ivy-split" , "telescope" , "vscode", "select" , "sidebar"
			-- override picker layout in keymaps function as a param below
			preset = "telescope", -- defaults to this layout unless overidden
			cycle = false,
		},
		layouts = {
			select = {
				preview = false,
				layout = {
					backdrop = false,
					width = 0.6,
					min_width = 80,
					height = 0.4,
					min_height = 10,
					box = "vertical",
					border = "rounded",
					title = "{title}",
					title_pos = "center",
					{ win = "input", height = 1, border = "bottom" },
					{ win = "list", border = "none" },
					{ win = "preview", title = "{preview}", width = 0.6, height = 0.4, border = "top" },
				},
			},
			telescope = {
				reverse = true, -- set to false for search bar to be on top
				layout = {
					box = "horizontal",
					backdrop = false,
					width = 0.8,
					height = 0.9,
					border = "none",
					{
						box = "vertical",
						{ win = "list", title = " Results ", title_pos = "center", border = "rounded" },
						{
							win = "input",
							height = 1,
							border = "rounded",
							title = "{title} {live} {flags}",
							title_pos = "center",
						},
					},
					{
						win = "preview",
						title = "{preview:Preview}",
						width = 0.50,
						border = "rounded",
						title_pos = "center",
					},
				},
			},
			ivy = {
				layout = {
					box = "vertical",
					backdrop = false,
					width = 0,
					height = 0.4,
					position = "bottom",
					border = "top",
					title = " {title} {live} {flags}",
					title_pos = "left",
					{ win = "input", height = 1, border = "bottom" },
					{
						box = "horizontal",
						{ win = "list", border = "none" },
						{ win = "preview", title = "{preview}", width = 0.5, border = "left" },
					},
				},
			},
		},
	},
})

vim.api.nvim_create_autocmd("User", {
	pattern = "OilActionsPost",
	callback = function(event)
		if event.data.actions[1].type == "move" then
			Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
		end
	end,
})

--- picker ---
key.set("n", "<leader>pf", function()
	Snacks.picker.files({ layout = "telescope" })
end, { desc = "Snacks file picker" })

key.set({ "n", "x" }, "<leader>ps", function()
	Snacks.picker.grep_word()
end, { desc = "Grep word/Search word" })

key.set("n", "<leader>pk", function()
	Snacks.picker.keymaps({ layout = "ivy" })
end, { desc = "Search Keymaps" })

key.set("n", "<leader>xx", function()
	Snacks.picker.diagnostics()
end, { desc = "Snacks diagnostics" })

key.set("n", "<leader>vh", function()
	Snacks.picker.help()
end, { desc = "Snacks Help" })

--- git ---
key.set("n", "<leader>lg", function()
	Snacks.lazygit.open()
end, { desc = "Snacks lazygit" })

key.set("n", "<leader>gi", function()
	Snacks.picker.gh_issue()
end, { desc = "GitHub Issues (open)" })

key.set("n", "<leader>gI", function()
	Snacks.picker.gh_issue({ state = "all" })
end, { desc = "GitHub Issues (all)" })

key.set("n", "<leader>gp", function()
	Snacks.picker.gh_pr()
end, { desc = "GitHub Pull Requests (open)" })

key.set("n", "<leader>gP", function()
	Snacks.picker.gh_pr({ state = "all" })
end, { desc = "GitHub Pull Requests (all)" })

--- dim ---
key.set("n", "<leader>di", function()
	if Snacks.dim.enabled then
		Snacks.dim.disable()
	else
		Snacks.dim.enable()
	end
end, { desc = "Dim" })

--- terminal ---
key.set("n", "<leader>th", function()
	Snacks.terminal.toggle(nil, { win = { position = "bottom" } })
end, { desc = "Open terminal horizontal split" })

key.set("n", "<leader>tv", function()
	Snacks.terminal.toggle(nil, { win = { position = "right" } })
end, { desc = "Open terminal veritcal split" })

key.set("n", "<leader>tt", function()
	Snacks.terminal.toggle(nil, { win = { position = "float" } })
end, { desc = "Open terminal floating window" })

--- notify ---
key.set("n", "<C-h>", function()
	Snacks.notifier.hide()
end, { desc = "Clear notification" })
