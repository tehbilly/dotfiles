return {
    "xzbdmw/colorful-menu.nvim",
    config = function()
        require("colorful-menu").setup({
            ls = {
                ["rust-analyzer"] = {
                    align_type_to_right = true,
                    preserve_type_when_truncate = true,
                },
            },
            max_width = 120,
        })
    end,
}