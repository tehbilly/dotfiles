-- nvim-treesitter `main` branch (full rewrite; the old `master` branch is frozen)
-- Docs: https://github.com/nvim-treesitter/nvim-treesitter/tree/main
--
-- Adding a language:
--   1. Check it's supported: https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
--   2. Add its parser name to `parsers` below (restart nvim, or run `:TSInstall <lang>` to try it first).
--   Unsupported parsers can be added manually; see "Adding custom languages" in the README.
--
-- Other things:
--   * Parsers are only installed from the list below; there is no `auto_install` on `main`.
--   * Highlighting, folds and indent are NOT automatic; they're enabled per-buffer in the FileType autocmd below.
--   * After plugin updates, parsers must be updated too (`:TSUpdate`, automated via `build`).
--   * Requires the `tree-sitter` CLI (not from npm) and a C compiler. Run `:checkhealth nvim-treesitter` if installs fail.
--   * This plugin does not support lazy-loading, hence `lazy = false`.
local parsers = {
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
  "markdown_inline",
  "rust",
  "typescript",
  "toml",
  "yaml",
  "zig",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
      callback = function(args)
        -- Errors if no parser is installed for this filetype; those buffers just skip treesitter
        if not pcall(vim.treesitter.start, args.buf) then
          return
        end
        -- Treesitter indent is experimental, see :h nvim-treesitter-indentation
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
