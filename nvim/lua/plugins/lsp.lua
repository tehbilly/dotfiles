return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "j-hui/fidget.nvim", opts = {} }, -- LSP feedback
    -- { "saghen/blink.cmp" }, -- Completions
  },
  -- Use config function to do complex setup
  config = function()
    -- TODO: Check for servers before enabling them
    local servers = {
      bashls = true,
      clangd = {
        init_options = { clangdFileStatus = true },
        filetyes = { "c" },
      },
      lua_ls = {
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
                -- "${3rd}/busted/library",
              },
            },
          })
        end,
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
    }

    -- Setup the LSP servers
    for name, cfg in pairs(servers) do
      if cfg == true then
        cfg = {}
      end

      vim.lsp.config(name, cfg)
      vim.lsp.enable(name)
    end
  end,
}
