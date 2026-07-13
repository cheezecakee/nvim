local key = vim.keymap
local last_tab_count = 0

local function setup_tab_keymaps()
	local tabs = vim.api.nvim_list_tabpages()
	local tab_count = #tabs

	for i = 1, tab_count do
		local k = string.format("t%s", i)
		local idx = i
		key.set("n", k, function()
			local current_tabs = vim.api.nvim_list_tabpages()
			if current_tabs[idx] then
				vim.api.nvim_set_current_tabpage(current_tabs[idx])
			end
		end, { desc = "Go to tab n" })
	end

	-- remove binds for indices that existed before but don't anymore
	if last_tab_count > tab_count then
		for i = tab_count + 1, last_tab_count do
			pcall(vim.keymap.del, "n", string.format("t%s", i))
		end
	end

	last_tab_count = tab_count
end

-- initial setup
setup_tab_keymaps()

-- update when tabs change or vim enter
vim.api.nvim_create_autocmd({ "TabNew", "TabClosed", "VimEnter" }, {
	group = vim.api.nvim_create_augroup("DynamicTabKeyMaps", { clear = true }),
	callback = setup_tab_keymaps,
})

local function open_buffer_list()
	local Snacks = require("snacks")
	local current_tab = vim.api.nvim_get_current_tabpage()
	local win
	local last_count = 0

	local function detach_elsewhere(bufnr)
		for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
			if vim.api.nvim_win_get_tabpage(winid) ~= current_tab then
				pcall(vim.api.nvim_win_close, winid, false)
			end
		end
	end

	local function render()
		local current_tab_buffers = {}
		for _, window in ipairs(vim.api.nvim_tabpage_list_wins(current_tab)) do
			current_tab_buffers[vim.api.nvim_win_get_buf(window)] = true
		end

		local buffer_list = {}
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			local name = vim.api.nvim_buf_get_name(buf)
			if name ~= "" and not name:match("%[.*%]") and name:match("%.") and not current_tab_buffers[buf] then
				table.insert(buffer_list, { bufnr = buf, name = vim.fn.fnamemodify(name, ":t") })
			end
		end

		local lines = {}
		for i, entry in ipairs(buffer_list) do
			table.insert(lines, string.format("  [%d] %s", i, entry.name))
		end
		if #lines == 0 then
			lines = { "No buffers outside current tab" }
		end
		vim.api.nvim_buf_set_lines(win.buf, 0, -1, false, lines)

		for i, entry in ipairs(buffer_list) do
			local idx = tostring(i)
			local opts = { buffer = win.buf, nowait = true, silent = true }

			key.set("n", idx, function()
				win:close()
				detach_elsewhere(entry.bufnr)
				vim.api.nvim_set_current_buf(entry.bufnr)
			end, opts)

			key.set("n", "d" .. idx, function()
				Snacks.bufdelete(entry.bufnr)
				render() -- redraw in place, no close/reopen
			end, opts)

			key.set("n", "s" .. idx, function()
				win:close()
				detach_elsewhere(entry.bufnr)
				vim.cmd("split")
				vim.api.nvim_set_current_buf(entry.bufnr)
			end, opts)

			key.set("n", "v" .. idx, function()
				win:close()
				detach_elsewhere(entry.bufnr)
				vim.cmd("vsplit")
				vim.api.nvim_set_current_buf(entry.bufnr)
			end, opts)
		end

		-- clean up stale binds beyond the new (shrunk) count
		if last_count > #buffer_list then
			for i = #buffer_list + 1, last_count do
				for _, prefix in ipairs({ "", "d", "s", "v" }) do
					pcall(vim.keymap.del, "n", prefix .. i, { buffer = win.buf })
				end
			end
		end
		last_count = #buffer_list
	end

	win = Snacks.win({
		width = 0.35,
		height = 0.3,
		border = "rounded",
		backdrop = false,
		title = "Buffers",
		title_pos = "left",
	})

	render()
end
key.set("n", "bl", open_buffer_list, { desc = "List buffers not in current tab" })
