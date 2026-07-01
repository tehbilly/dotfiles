-- Goofball extension test
local just_picker = function(opts)
  local t_actions = require("telescope.actions")
  local t_action_state = require("telescope.actions.state")
  local t_pickers = require("telescope.pickers")
  local t_finders = require("telescope.finders")
  local t_preview = require("telescope.previewers")
  local t_config = require("telescope.config").values

  local opts = opts or {}

  -- Fetch recipes
  local handle = io.popen("just --summary")
  local result = handle:read("*a")
  handle:close()

  local recipes = {}
  for recipe in result:gmatch("%S+") do
    table.insert(recipes, recipe)
  end

  t_pickers.new(opts, {
    prompt_title = "Just Recipes",
    finder = t_finders.new_table({
      results = recipes,
    }),
    sorter = t_config.generic_sorter(opts),

    -- previewer = t_preview.new_termopen_previewer({
    --   get_command = function(entry)
    --     return { "just", "--show", entry.value }
    --   end,
    -- }),
    previewer = t_preview.new_buffer_previewer({
      title = "Recipe Definition",
      define_preview = function(self, entry, status)
        -- Pipe output to the preview buffer
        vim.fn.jobstart({ "just", "--show", entry.value }, {
          on_stdout = function(_, data)
            if data then
              vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, data)
            end
          end,
          stdout_buffered = true,
        })

        vim.api.nvim_set_option_value("filetype", "just", { buf = self.state.bufnr })
      end,
    }),

    attach_mappings = function(prompt_bufnr, map)
      t_actions.select_default:replace(function()
        t_actions.close(prompt_bufnr)
        -- local select = t_action_state.get_selected_entry()
        -- vim.cmd("split | term just " .. select.value)
        -- vim.cmd("startinsert")
      end)
      return true
    end,
  }):find()
end

return {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            -- I don't like having to hit <esc> twice to exit, and I don't use the other mappings that require it,
            -- so just have it close the picker immediately
            ["<esc>"] = actions.close,
          },
        },
        path_display = function(opts, path)
          local path = path:gsub("\\", "/") -- replace backslashes with forward slashes
          local last_slash_idx = path:find("/[^/]*$") -- find the last slash and the following characters

          -- This dims the path portion, letting the filename stand out more.
          if last_slash_idx then
            local highlights = {
              {
                { 0, last_slash_idx }, -- start, end
                "Comment", -- Highlight group name
              },
            }
            return path, highlights
          end

          return path
        end,
        winblend = 0,
        border = true,
      },
      pickers = {
        find_files = {
          file_ignore_patterns = { ".git/" },
          hidden = true,
        },
      },
      extensions = {
        fzf = {},
        wrap_results = true,
      },
    })

    pcall(require("telescope").load_extension, "fzf")

    local builtin = require("telescope.builtin")

    -- General helpers
    vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "List open buffers in current instance" })
    vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Search commands" })
    -- vim.keymap.set("n", "<leader>fq", builtin.quickfix, { desc = "List items in quickfix list" })
    vim.keymap.set("n", "<leader>fr", builtin.registers, { desc = "List vim regisers, pastes content when selected" })
    vim.keymap.set("n", "<leader>fp", builtin.pickers, { desc = "Lists pickers" })
    vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "List keymaps" })
    vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "List recently opened files" })
    vim.keymap.set("n", "<leader>fp", builtin.builtin, { desc = "List built-in pickers" })
    -- Code/LSP helpers
    -- vim.keymap.set("n", "<leader>ca", builtin.lsp_code_actions, { desc = "LSP code actions" })
    vim.keymap.set("n", "<leader>cr", builtin.lsp_references, { desc = "LSP references" })
    vim.keymap.set("n", "<leader>cs", builtin.lsp_document_symbols, { desc = "LSP document symbols" })
    vim.keymap.set("n", "<leader>cd", builtin.lsp_definitions, { desc = "LSP Definitions" })
    -- File/workspace helpers
    vim.keymap.set("n", "<leader>fd", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Search in buffer" })
    vim.keymap.set("n", "<leader>gw", builtin.grep_string, { desc = "Grep word under cursor" })

    vim.keymap.set("n", "<leader>jj", just_picker, { desc = "Just recipes" })
  end,
}
