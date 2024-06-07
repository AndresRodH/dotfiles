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
			{ "<leader>e", "<cmd>Oil --float<CR>", desc = "Open file [E]xplorer" },
		},
		opts = {
			default_file_explorer = true,
			show_hidden = true,
      is_hidden_file = function(name, bufnr)
        return vim.startswith(name, ".") and !vim.startsWith(name, ".server") and !vim.startsWith(name, ".client")
      end,
			keymaps = {
				["q"] = "actions.close",
				["<C-h>"] = false,
				["<C-l>"] = false,
			},
		},
	},
}
