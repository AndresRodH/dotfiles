return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			keymaps = {
				["q"] = "actions.close",
				["<C-h>"] = false,
				["<C-l>"] = false,
			},
		},
	},
}
