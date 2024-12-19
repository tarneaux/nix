local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local widget = wibox.widget.textbox()

local icon = " "

local function daemon()
	awful.spawn.easy_async_with_shell("unison-status", function(stdout)
		widget:set_markup(icon .. stdout)
	end)
end

gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = daemon,
})

return widget
