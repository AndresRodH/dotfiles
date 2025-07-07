local icons = require("icons")
local colors = require("colors")

local battery = sbar.add("item", {
	position = "right",
	icon = {
		font = {
			style = "Regular",
			size = 19.0,
		},
	},
	label = {
		padding_left = 8,
	},
	update_freq = 120,
})

local function battery_update()
	sbar.exec("pmset -g batt", function(batt_info)
		local icon = "!"
		local found, _, charge = batt_info:find("(%d+)%%")

		if string.find(batt_info, "AC Power") then
			icon = icons.battery.charging
			battery:set({ icon = { color = colors.green } })
			if found then
				battery:set({ label = charge .. "%" })
			end
		else
			battery:set({ icon = { color = colors.white } })
			local total_charge = nil
			if found then
				total_charge = tonumber(charge)
			end

			if found and total_charge > 80 then
				icon = icons.battery._100
			elseif found and total_charge > 60 then
				icon = icons.battery._75
			elseif found and total_charge > 40 then
				icon = icons.battery._50
			elseif found and total_charge > 20 then
				icon = icons.battery._25
			else
				icon = icons.battery._0
			end
		end

		battery:set({ icon = icon })
	end)
end

battery:subscribe({ "routine", "power_source_change", "system_woke" }, battery_update)
