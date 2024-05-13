return {
	-- disable neo-tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		enabled = false,
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>e", "<cmd>Oil<CR>", desc = "Open file [E]xplorer" },
		},
		opts = {
			default_file_explorer = true,
			keymaps = {
				["q"] = "actions.close",
				["<C-l>"] = false,
				["<C-h>"] = false,
			},
		},
	},
}
