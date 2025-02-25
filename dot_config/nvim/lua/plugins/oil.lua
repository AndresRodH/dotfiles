return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			default_file_explorer = true,
			keymaps = {
				["q"] = "actions.close",
				["<C-h>"] = false,
				["<C-l>"] = false,
			},
		},
	},
}
