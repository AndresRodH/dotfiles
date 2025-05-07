return {
	{

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
					filetypes = { "graphql", "typescriptreact", "javascriptreact", "vue" },
				},
			},
		},
		-- pinning mason until the distro gets updated to support mason 2
		{
			{
				"williamboman/mason.nvim",
				version = "1.11.0",
			},
			{
				"mason-org/mason-lspconfig.nvim",
				version = "1.32.0",
			},
		},
	},
}
