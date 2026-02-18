return {
  "mason-org/mason.nvim",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  opts = {},
  config = function(_, opts)
    require("mason").setup(opts)

    require("mason-tool-installer").setup({
      ensure_installed = {
        -- bash
        "shfmt",
        "bash-language-server",
        -- lua
        "lua-language-server",
        "stylua",
        -- rust
        "rust-analyzer",
        -- typescript
        "deno",
        -- zig
        "zls",
      },
    })
  end,
}
