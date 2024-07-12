return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "go",
      "html",
      "just",
      "json",
      "json5",
      "lua",
      "luadoc",
      "markdown",
      "rust",
      "typescript",
      "toml",
      "yaml",
      "zig",
    },
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      -- If you are experiencing weird indenting issues, add the language to the list of
      -- additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = {},
    },
    indent = { enable = true, disable = {} },
  },
}
