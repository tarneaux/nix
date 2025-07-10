local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local function widget(profile)
	local w = wibox.widget.textbox()

	local function daemon()
		awful.spawn.easy_async_with_shell("unisond-status " .. profile, function(stdout)
			w:set_markup(stdout)
		end)
	end

	gears.timer({
		timeout = 1,
		call_now = true,
		autostart = true,
		callback = daemon,
	})

	return w
end

local spacer = wibox.widget.textbox()
spacer:set_text("/")

local icon = wibox.widget.textbox()
icon:set_text(" ")

return wibox.widget({
	{
		icon,
		widget("dotsync"),
		layout = wibox.layout.align.horizontal,
	},
	spacer,
	widget("space"),
	layout = wibox.layout.align.horizontal,
})
