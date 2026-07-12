local o = vim.opt

vim.g.netrw_banner = 0

o.termguicolors = true
vim.cmd.colorscheme("catppuccin")

o.nu = true
o.relativenumber = true

-- shell --
if vim.fn.has("win32") == 1 then
	o.shell = "pwsh"
	o.shellquote = ""
	o.shellpipe = "|"
	o.shellxquote = ""
	o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
	o.shellredir = "| Out-File -Encoding UTF8"
else
	o.shell = "/run/current-system/sw/bin/bash"
end

-- indentation
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true
o.wrap = false

-- search
o.inccommand = "split"

-- window splits
o.splitbelow = true
o.splitright = true

o.ignorecase = true
o.smartcase = true
o.laststatus = 3

-- backup and undo
o.swapfile = false
o.backup = false
o.undodir = vim.fn.stdpath("data") .. "/undodir"
o.undofile = true

o.completeopt = "menuone,noselect,fuzzy,nosort"
o.shortmess:append("c")
o.isfname:append("@-@")

-- UI
o.scrolloff = 8
o.signcolumn = "yes"

-- folding
o.foldenable = true
o.foldmethod = "manual"
o.foldlevel = 99
o.foldcolumn = "0"

-- misc
--o.guicursor = ""
o.clipboard:append("unnamedplus")
o.colorcolumn = "0"
o.cmdheight = 0
o.mouse = "a"

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Hightlight when yanking (copying) text",
	callback = function()
		vim.hl.on_yank()
	end,
})
