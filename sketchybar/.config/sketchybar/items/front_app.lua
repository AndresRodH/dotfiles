local app_icons = require("helpers.app_icons")

local front_app = sbar.add("item", {
	icon = {
		font = "sketchybar-app-font:Regular:16.0",
	},
	label = {
		font = {
			style = "Black",
			size = 12.0,
		},
	},
})

front_app:subscribe("front_app_switched", function(env)
	local lookup = app_icons[env.INFO]
	local icon = ((lookup == nil) and app_icons["Default"] or lookup)
	front_app:set({
		label = {
			string = env.INFO,
		},
		icon = {
			string = icon,
		},
	})

	-- Or equivalently:
	-- sbar.set(env.NAME, {
	--   label = {
	--     string = env.INFO
	--   }
	-- })
end)
