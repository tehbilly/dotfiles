return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    dependencies = {
      { "gonstoll/wezterm-types", lazy = true },
    },
    opts = {
      library = {
        "lazy.nvim",
        -- load when 'wezterm' module is required
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
    { -- blink completion source for require statements and module annotations
      "saghen/blink.cmp",
      opts = {
        sources = {
          default = { "lazydev", "lsp", "path", "snippets", "buffer" },
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              -- make lazydev completions top priority
              score_offset = 100,
            },
          },
        },
      },
    },
  },
}
