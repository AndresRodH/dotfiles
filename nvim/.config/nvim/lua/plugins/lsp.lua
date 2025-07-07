return {
	"neovim/nvim-lspconfig",
	opts = {
		diagnostics = {
			float = {
				border = "rounded",
			},
		},
		servers = {
			vtsls = {
				settings = {
					typescript = {
						tsserver = {
							maxTsServerMemory = 8192,
						},
					},
				},
			},
			graphql = {
				filetypes = { "graphql", "typescriptreact", "javascriptreact", "vue", "typescript", "javascript" },
			},
		},
	},
}
