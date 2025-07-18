return {
  "mason-org/mason.nvim",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  opts = {},
  config = function(plugin, opts)
    local mason = require("mason")
    local tool_installer = require("mason-tool-installer")

    mason.setup(opts)

    tool_installer.setup({
      ensure_installed = {
        -- bash
        "shfmt",
        "bash-language-server",
        -- lua
        -- "emmylua_ls"
        "lua-language-server",
        "stylua",
        -- rust
        "rust-analyzer",
        -- typescript
        "deno",
      },
    })
  end,
}
