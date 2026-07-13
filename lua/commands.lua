-- vim.pack --
vim.api.nvim_create_user_command("PackAdd", function(opts)
	vim.pack.add(opts.fargs)
end, { nargs = "+", desc = "Add plugins (:PackAdd user/repo1 user/repo2)" })

vim.api.nvim_create_user_command("PackDel", function(opts)
	vim.pack.del(opts.fargs)
end, { nargs = "+", desc = "Delete plugins (:PackDel user/repo1 user/repo2)" })

vim.api.nvim_create_user_command("PackUpdate", function(opts)
	-- checks if eny argument is passed
	if opts.args:match("%S") then
		-- update specific plugins
		local plugins = vim.split(opts.args, "%s+", { trimempty = true })
		-- update only specified plugins
		vim.pack.update(plugins)
	else
		-- update all
		vim.pack.update()
	end
end, { nargs = "*", desc = "Update all plugins or specific ones" })

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- install all mason packages listed
vim.api.nvim_create_user_command("MasonInstallAll", function()
	local pkg_name = {
		biomejs = "biome",
		["biome-check"] = "biome",
		lua_ls = "lua-language-server",
	}

	-- helper function to find if value is in table.
	local function table_contains(table, value)
		for _, v in ipairs(table) do
			if v == value then
				return true
			end
		end
		return false
	end

	local linters = require("lint").linters_by_ft
	local lsps = vim.tbl_keys(vim.lsp._enabled_configs)
	local formatters = require("conform").formatters_by_ft

	local install_list = {}

	-- add lsps to the list
	for _, lsp in ipairs(lsps) do
		local pkg = pkg_name[lsp] or lsp
		table.insert(install_list, pkg)
	end

	-- add linters to the list
	for _, i in pairs(linters) do
		for _, linter in ipairs(i) do
			local pkg = pkg_name[linter] or linter
			if not table_contains(install_list, pkg) then
				table.insert(install_list, pkg)
			end
		end
	end

	-- add formatters to the list
	for _, i in pairs(formatters) do
		for _, formatter in ipairs(i) do
			local pkg = pkg_name[formatter] or formatter
			if not table_contains(install_list, pkg) then
				table.insert(install_list, pkg)
			end
		end
	end

	-- install list --
	local registry = require("mason-registry")
	local installed = registry.get_installed_package_names()

	for _, i in ipairs(install_list) do
		if not table_contains(installed, i) then
			vim.cmd("MasonInstall " .. i)
		end
	end
end, { nargs = "*", desc = "Installs LSP|Linters|Formatters from config list" })
