return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "j-hui/fidget.nvim", opts = {} }, -- LSP feedback
  },
  -- Use config function to do complex setup
  config = function()
    local capabilities = nil
    if pcall(require, "cmp_nvim_lsp") then
      capabilities = require("cmp_nvim_lsp").default_capabilities()
    end

    local lspconfig = require("lspconfig")

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
          if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
                -- "${3rd}/busted/library",
              }
            }
          })
        end,
        settings = {
          Lua = {}
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

    -- local to_install = vim.tbl_filter(function(key)
    --   local t = servers[key]
    --   if type(t) == "table" then
    --     return not t.manual_install
    --   elseif type(t) == "boolean" then
    --     return t
    --   end
    --   -- TODO: Log warning?
    --   return false
    -- end, vim.tbl_keys(servers))

    -- Setup the LSP servers
    for name, cfg in pairs(servers) do
      if cfg == true then
        cfg = {}
      end
      cfg = vim.tbl_deep_extend("force", {}, {
        capabilities = capabilities,
      }, cfg)

      lspconfig[name].setup(cfg)
    end
  end
}
