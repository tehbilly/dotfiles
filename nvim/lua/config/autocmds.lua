-- Autocommands

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight text on yank
autocmd("TextYankPost", {
  group = augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Resize splits when window is resized
autocmd("VimResized", {
  group = augroup("resize-splits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- LSP keybindings (only active when an LSP server is attached)
autocmd("LspAttach", {
  group = augroup("lsp-keymaps", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gr", vim.lsp.buf.references, "References")
    map("gI", vim.lsp.buf.implementation, "Go to implementation")
    map("gy", vim.lsp.buf.type_definition, "Go to type definition")
    map("K", vim.lsp.buf.hover, "Hover documentation")
    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "Code actions", { "n", "v" })
    map("<leader>ds", vim.lsp.buf.document_symbol, "Document symbols")
    map("<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace symbols")
  end,
})

-- Configure LSP hover/signature borders
autocmd("LspAttach", {
  group = augroup("lsp-borders", { clear = true }),
  once = true,
  callback = function()
    vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
      config = config or {}
      config.border = "rounded"
      return vim.lsp.handlers.hover(_, result, ctx, config)
    end

    vim.lsp.handlers["textDocument/signatureHelp"] = function(_, result, ctx, config)
      config = config or {}
      config.border = "rounded"
      return vim.lsp.handlers.signatureHelp(_, result, ctx, config)
    end
  end,
})
