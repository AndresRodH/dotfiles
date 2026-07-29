return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = function()
				vim.cmd.colorscheme(vim.o.background == "dark" and "catppuccin-mocha" or "catppuccin-latte")
			end,
		},
	},
}
