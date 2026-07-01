return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- Optional deps
    "nvim-tree/nvim-web-devicons",
    -- Image preview
    "folke/snacks.nvim",
    -- LSP for commands
    "antosha417/nvim-lsp-file-operations",
    -- Window picker
    "s1n7ax/nvim-window-picker",

  },
  opts = {
    close_if_last_window = true,
    window = {
        position = "float",
        popup = {
            size = { height = "80%", width = "80%" },
            position = "50%",
            border = "rounded",
        },
    },
    filesystem = {
      filtered_items = {
        visible = true,
      },
    },
    source_selector = {
      winbar = false,
      statusline = true,
    },
    event_handlers = {
        {
            event = "file_opened",
            handler = function(file_path)
                -- auto-close neo-tree
                require("neo-tree.command").execute({ action = "close" })
            end,
        },
    },
  },
  config = function(plugin, opts)
    require("neo-tree").setup(opts)

    -- Force neo-tree floating border background to be transparent
    vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { bg = "NONE" })

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
      local command = require("neo-tree.command")
      command.execute({
        toggle = false,
        reveal_file = reveal_file,
        reveal_force_cwd = false,
      })
    end, { desc = "Open neotree at current file or working directory" })
  end,
}
