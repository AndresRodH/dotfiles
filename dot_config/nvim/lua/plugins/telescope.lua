local Util = require("lazyvim.util")

return {
	"nvim-telescope/telescope.nvim",
	keys = {
		-- enable finding hidden/dot files
		{
			"<leader><leader>",
			Util.pick("files", { hidden = true, no_ignore = false }),
			desc = "Find files (root dir)",
		},
		{
			"<leader>ff",
			Util.pick("files", { hidden = true, no_ignore = false }),
			desc = "Find files (root dir)",
		},
		{
			"<leader>fF",
			Util.pick("files", { cwd = nil, hidden = true, no_ignore = false }),
			desc = "Find files (cwd)",
		},
		{
			"<leader>fF",
			Util.pick("files", { cwd = nil, hidden = true, no_ignore = false }),
			desc = "Find files (cwd)",
		},
	},
}
