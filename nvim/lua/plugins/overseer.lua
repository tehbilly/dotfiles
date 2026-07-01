return {
  "stevearc/overseer.nvim",
  ---@module 'overseer'
  ---@type overseer.SetupOpts
  opts = {
    output = {
      use_terminal = true,
    },
  },
  config = function(_, opts)
    local overseer = require("overseer")
    overseer.setup(opts)

    vim.keymap.set("n", "<leader>ot", overseer.toggle, { desc = "Toggle overseer task list" })
  end,
}
