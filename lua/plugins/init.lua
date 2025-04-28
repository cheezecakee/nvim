return {
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        config = function()
            require("configs.conform")
        end,
    },
    {
        "zapling/mason-conform.nvim",
        event = "VeryLazy",
        dependencies = { "conform.nvim" },
        config = function()
            require("configs.mason-conform")
        end,
    },
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.lint")
        end,
    },
    {
        "rshkarin/mason-nvim-lint",
        event = "VeryLazy",
        dependencies = { "nvim-lint" },
        config = function()
            require("configs.mason-lint")
        end,
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvchad.configs.lspconfig").defaults()
            require("configs.lspconfig")
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lspconfig" },
        config = function()
            require("configs.mason-lspconfig")
        end,
    },
    {
        "akinsho/flutter-tools.nvim",
        event = { "BufReadPre", "BufNewFile" },
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "stevearc/dressing.nvim", -- optional for vim.ui.select
        },
        config = function()
            require("configs.flutter-tools")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.treesitter")
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        -- tag = "v3.09.0", -- Replace this with the latest v2.x version
        event = "User FilePost",
        opts = {
            char = "│",
            show_trailing_blankline_indent = false,
        },
        config = function(_, opts)
            require("indent_blankline").setup(opts)
        end,
    },
    {
        "olexsmir/gopher.nvim",
        ft = "go",
        config = function(_, opts)
            require("gopher").setup(opts)
        end,
        build = function()
            vim.cmd([[silent! GoInstallDeps]])
        end,
    },
    {
        "folke/twilight.nvim",
        opts = {
            -- your configuration comes here
        },
        init = function() end,
        cmd = { "Twilight" },
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "leoluz/nvim-dap-go",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
        },
        init = function()
            require("configs.dap")
        end,
    },
    {
        "ThePrimeagen/vim-be-good",
        init = function() end,
        cmd = "VimBeGood",
    },
    {
        "mhinz/vim-startify",
        event = "VeryLazy",
        init = function() end,
        cmd = "Startify",
    },
    {
        "ggandor/leap.nvim",
        config = function()
            require("nvchad.mappings")
            require("leap").create_default_mappings()
        end,
    },
    {
        "stevearc/dressing.nvim",
        opts = {},
        init = function() end,
    },
    {
        "windwp/nvim-ts-autotag",
        ft = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
        },
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },
    {
        "shortcuts/no-neck-pain.nvim",
        event = { "VeryLazy" },
        init = function() end,
        cmd = "NoNeckPain",
    },
    {
        "nvim-tree/nvim-web-devicons",
        opts = {},
        init = function() end,
        cmd = "",
    },
    -- {
    --     "mrcjkb/haskell-tools.nvim",
    --     version = "^4", -- Recommended
    --     lazy = false, -- This plugin is already lazy
    -- },
    -- {
    --     "jackMort/ChatGPT.nvim",
    --     event = "VeryLazy",
    --     config = function()
    --         require("chatgpt").setup()
    --     end,
    --     dependencies = {
    --         "MunifTanjim/nui.nvim",
    --         "nvim-lua/plenary.nvim",
    --         "folke/trouble.nvim",
    --         "nvim-telescope/telescope.nvim",
    --     },
    -- },
    ---- {
    --     "shellRaining/hlchunk.nvim",
    --     event = { "BufReadPre", "BufNewFile" },
    --     config = function()
    --         require("configs.hlchunk")
    --     end,
    -- },
}
