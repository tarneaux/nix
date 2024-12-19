local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local textbox = wibox.widget.textbox()

local logo = wibox.widget({
	layout = wibox.layout.stack,
	{
		markup = "󰔶 ",
		widget = wibox.widget.textbox(),
	},
	{
		markup = '<span foreground="' .. beautiful.background .. '">󰜥 </span>',
		valign = "bottom",
		widget = wibox.widget.textbox(),
	},
})

local connected = false

local function daemon()
	awful.spawn.easy_async_with_shell(
		'dbus-send --print-reply=literal --system --dest=org.bluez /org/bluez/hci0/dev_D3_69_8F_B1_D3_FB org.freedesktop.DBus.Properties.Get string:"org.bluez.Battery1" string:"Percentage"',
		function(stdout)
			local percentage = tonumber(stdout:match("byte (%d+)"))
			if percentage then
				textbox:set_text(percentage .. "%")
				if connected == false then
					awful.spawn.with_shell("xset r rate 300 50")
				end
				connected = true
			else
				textbox:set_text(" ")
				connected = false
			end
		end
	)
end

gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = daemon,
})

local widget = wibox.widget({
	layout = wibox.layout.align.horizontal,
	logo,
	textbox,
})

return widget
