return {
  "saecki/crates.nvim",
  -- tag = "stable",
  event = { "BufRead Cargo.toml" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local crates = require("crates")

    crates.setup({
      completion = {
        crates = {
          enabled = true,
          max_results = 10,
          min_chars = 3,
        },
        -- lsp = {
        --   enabled = true,
        --   actions = true,
        --   completion = true,
        --   hover = true,
        -- },
        blink = {
          use_custom_kind = true,
          kind_text = {
            version = "Version",
            feature = "Feature",
          },
          kind_highlight = {
            version = "BlinkCmpKindVersion",
            feature = "BlinkCmpKindFeature",
          },
          kind_icon = {
            version = " ",
            feature = " ",
          },
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    })
  end,
}
