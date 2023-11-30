-- test print
-- print("hello from ccls")
require("ccls").setup {
    lsp = {
        -- check :help vim.lsp.start for config options
        server = {
            name = "ccls", --String name
            cmd = {"/usr/bin/ccls"}, -- point to your binary, has to be a table
            args = {--[[Any args table]] },
            offset_encoding = "utf-32", -- default value set by plugin
            root_dir = vim.fs.dirname(vim.fs.find({ "compile_commands.json", ".git" }, { upward = true })[1]), -- or some other function that returns a string
            --on_attach = your_func,
            --capabilites = your_table/func
        },
    },
}
