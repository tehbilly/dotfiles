return {
  "neovim/nvim-lspconfig",
  config = function()
    local servers = {
      bashls = true,
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
      rust_analyzer = true,
      denols = true,
      zls = true,
    }

    -- Binary names that differ from the LSP server name
    local server_binaries = {
      bashls = "bash-language-server",
      lua_ls = "lua-language-server",
      rust_analyzer = "rust-analyzer",
      denols = "deno",
    }

    for name, cfg in pairs(servers) do
      if cfg == true then
        cfg = {}
      end

      -- Only enable servers whose binary is available
      local bin = server_binaries[name] or name
      if vim.fn.executable(bin) == 1 then
        vim.lsp.config(name, cfg)
        vim.lsp.enable(name)
      end
    end
  end,
}
