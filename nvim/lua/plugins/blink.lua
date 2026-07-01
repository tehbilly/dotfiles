return {
    "saghen/blink.cmp",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },

    version = "1.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "enter",
            -- Only accept with enter when an item has been explicitly selected
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<CR>"] = { "accept", "fallback" },
        },

        appearance = {
            nerd_font_variant = "mono",
        },

        completion = {
            trigger = {
                show_on_keyword = true,
                show_on_trigger_character = true,
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
                window = { border = "rounded" },
            },
            menu = {
                auto_show = true, -- Only show when manually invoked
                border = "rounded",
                draw = {
                    treesitter = { "lsp" },
                    columns = {
                        { "kind_icon",   "label",     gap = 1 },
                        { "source_name", "source_id", gap = 1 },
                    },
                    components = {
                        label = {
                            width = { fill = true },
                            text = function(ctx)
                                return require("colorful-menu").blink_components_text(ctx)
                            end,
                            highlight = function(ctx)
                                return require("colorful-menu").blink_components_highlight(ctx)
                            end,
                        },
                    },
                },
            },
            ghost_text = {
                enabled = true,
                show_with_menu = false,
            },
            list = {
                max_items = 25,
                selection = {
                    -- Do not preselect first item: allows accept/fallback to work properly
                    preselect = false,
                },
            },
        },
        signature = {
            enabled = true,
            window = { border = "rounded" },
        },

        sources = {
            default = {
                "lsp",
                "path",
                "snippets",
                "buffer",
            },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
}
