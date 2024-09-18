local options = {
    ensure_installed = {
        "bash",
        "c",
        "cmake",
        "css",
        "cpp",
        "dockerfile",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",
        "html",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "powershell",
        "printf",
        "python",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
    },

    highlight = {
        enable = true,
        use_languagetree = true,
    },

    indent = { enable = true },
}

require("nvim-treesitter.configs").setup(options)
