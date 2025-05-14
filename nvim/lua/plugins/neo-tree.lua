return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        close_if_last_window = true,
        filesystem = {
            filtered_items = {
                visible = true,
            },
        },
        -- event_handlers = {
        --   { -- TODO: Add 'neo_tree_buffer_leave' handler to restore cursor
        --     event = 'neo_tree_buffer_enter',
        --     handler = function()
        --       -- This effectively hides the cursor
        --       vim.cmd('highlight! Cursor blend=100')
        --     end
        --   },
        -- },
        source_selector = {
            winbar = false,
            statusline = true,
        },
    },
    config = function(plugin, opts)
        require("neo-tree").setup(opts)

        vim.keymap.set("n", "<leader>n", function()
            local reveal_file = vim.fn.expand("%:p")
            if reveal_file == "" then
                reveal_file = vim.fn.getcwd()
            else
                local f = io.open(reveal_file, "r")
                if f then
                    f.close(f)
                else
                    reveal_file = vim.fn.getcwd()
                end
            end
            require("neo-tree.command").execute({
                toggle = true,
                reveal_file = reveal_file,
                reveal_force_cwd = true,
            })
        end, { desc = "Open neotree at current file or working directory" })
    end,
}
