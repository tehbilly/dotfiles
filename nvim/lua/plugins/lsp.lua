return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
  },
  config = function()
    -- Servers are installed by mason.nvim (see mason.lua) and enabled by mason-lspconfig's `automatic_enable`.
    -- This table only holds per-server overrides.
    local servers = {
      clangd = {
        init_options = { clangdFileStatus = true },
        filetypes = { "c" },
      },
      lua_ls = {
        settings = {
          Lua = {},
        },
      },
      gopls = {
        settings = {
          gopls = {
            buildFlags = { "-tags=unit integration" },
          },
        },
      },
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              buildScripts = { enable = true },
            },
            procMacro = { enable = true },
          },
        },
      },
    }

    vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

    for name, cfg in pairs(servers) do
      vim.lsp.config(name, cfg)
    end
  end,
}
