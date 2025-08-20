local colors = require("colors")

local function parse_string_to_table(s)
	local result = {}
	for line in s:gmatch("([^\n]+)") do
		table.insert(result, line)
	end
	return result
end

local file = io.popen("aerospace list-workspaces --all")

if not file then
	print("Failed to run aerospace list-workspaces command")
	return
end

local result = file:read("*a")
file:close()

if not result or result == "" then
	print("No workspaces found")
	return
end

local workspaces = parse_string_to_table(result)

for i, workspace in ipairs(workspaces) do
	local space = sbar.add("item", "space." .. i, {
		icon = {
			string = workspace,
			padding_left = 10,
			padding_right = 10,
			color = colors.white,
			highlight_color = colors.red,
		},
		padding_left = 2,
		padding_right = 2,
		label = {
			padding_right = 20,
			color = colors.grey,
			highlight_color = colors.white,
			y_offset = -1,
			drawing = false,
		},
	})

	space:subscribe("aerospace_workspace_change", function(env)
		local selected = env.FOCUSED_WORKSPACE == workspace

		space:set({
			icon = { highlight = selected },
			label = { highlight = selected },
		})
	end)
end

local _ = sbar.add("item", {
	padding_left = 10,
	padding_right = 8,
	icon = {
		string = "􀆊",
		font = {
			style = "Heavy",
			size = 16.0,
		},
	},
	label = { drawing = false },
	associated_display = "active",
})
