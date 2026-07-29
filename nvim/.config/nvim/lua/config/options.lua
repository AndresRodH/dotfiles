local function macos_background()
	local result = vim.system({ "defaults", "read", "-g", "AppleInterfaceStyle" }, { text = true }):wait()
	return result.code == 0 and result.stdout:match("Dark") and "dark" or "light"
end

local function catppuccin_colorscheme(background)
	return background == "dark" and "catppuccin-mocha" or "catppuccin-latte"
end

local function sync_macos_background()
	local background = macos_background()
	local colorscheme = catppuccin_colorscheme(background)
	if vim.o.background == background and vim.g.colors_name == colorscheme then
		return
	end

	vim.o.background = background
	if (vim.g.colors_name or ""):find("catppuccin") then
		vim.cmd.colorscheme(colorscheme)
	end
end

vim.o.background = macos_background()

vim.api.nvim_create_autocmd({ "FocusGained", "TermResponse", "VimEnter", "VimResume" }, {
	callback = sync_macos_background,
})

vim.api.nvim_create_autocmd("OptionSet", {
	pattern = "background",
	callback = function()
		vim.schedule(sync_macos_background)
	end,
})

vim.defer_fn(sync_macos_background, 100)

vim.opt.pumblend = 0
vim.scrolloff = 8
