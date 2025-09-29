local options = {
    chunk = {
        enable = true,
        style = {
            "#806d9c", -- Violet
            "#c21f30", -- maple red
        },
        chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "╭",
            left_bottom = "╰",
            right_arrow = ">",
        },
        notify = false,
        priority = 0,
        exclude_filetypes = {
            aerial = true,
            dashboard = true,
            -- some other filetypes
        },
    },
    indent = {
        enable = true, -- Enable the indent mod if needed
        -- Add specific indent mod configuration here
    },
    line_num = {
        enable = false, -- Disable the line number mod by default
    },
    blank = {
        enable = false, -- Disable the blank mod by default
    },
}

require("hlchunk").setup(options)
