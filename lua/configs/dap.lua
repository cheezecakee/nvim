require("nvchad.mappings")
local dap = require("dap")
local ui = require("dapui")
local map = vim.keymap.set

require("dapui").setup()
require("dap-go").setup()
require("nvim-dap-virtual-text").setup({
    -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
    display_callback = function(variable)
        local name = string.lower(variable.name)
        local value = string.lower(variable.value)
        if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
            return "*****"
        end

        if #variable.value > 15 then
            return " " .. string.sub(variable.value, 1, 15) .. "... "
        end

        return " " .. variable.value
    end,
})

-- Handled by nvim-dap-go
dap.adapters.go = {
    type = "server",
    port = "${port}",
    executable = {
        command = "dlv",
        args = { "dap", "-l", "127.0.0.1:${port}" },
    },
}

local elixir_ls_debugger = vim.fn.exepath("elixir-ls-debugger")
if elixir_ls_debugger ~= "" then
    dap.adapters.mix_task = {
        type = "executable",
        command = elixir_ls_debugger,
    }

    dap.configurations.elixir = {
        {
            type = "mix_task",
            name = "phoenix server",
            task = "phx.server",
            request = "launch",
            projectDir = "${workspaceFolder}",
            exitAfterTaskReturns = false,
            debugAutoInterpretAllModules = false,
        },
    }
end

map("n", "<leader>db", dap.toggle_breakpoint)
map("n", "<leader>dgb", dap.run_to_cursor)

-- Eval var under cursor
map("n", "<leader>?", function()
    require("dapui").eval(nil, { enter = true })
end)

map("n", "<F1>", dap.continue)
map("n", "<F2>", dap.step_into)
map("n", "<F3>", dap.step_over)
map("n", "<F4>", dap.step_out)
map("n", "<F5>", dap.step_back)
map("n", "<F13>", dap.restart)

dap.listeners.before.attach.dapui_config = function()
    ui.open()
end
dap.listeners.before.launch.dapui_config = function()
    ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    ui.close()
end
