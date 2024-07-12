-- Completions!
return {
  "hrsh7th/nvim-cmp",

  -- Until https://github.com/hrsh7th/nvim-cmp/issues/1877 is resolved
  commit = "b356f2c",
  pin = true,

  lazy = false,
  priority = 100,
  dependencies = {
    "neovim/nvim-lspconfig", -- Used by cmp-nvim-lsp
    "onsails/lspkind.nvim",  -- vscode-like pictograms
    "hrsh7th/cmp-nvim-lsp",  -- lsp source
    "hrsh7th/cmp-buffer",    -- buffer source
    -- "hrsh7th/cmp-path", -- path source
  },
  config = function()
    local cmp = require("cmp")
    cmp.setup({
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- elseif luasnip.expand_or_jumpable() then
            --   luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
            -- elseif luasnip.jumpable(-1) then
            --   luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
      }),
    })
  end,
}
