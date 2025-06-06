local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local icon = wibox.widget.textbox("󰝚 ")
local title = wibox.widget.textbox()

local function daemon()
	awful.spawn.easy_async_with_shell("rmpc song | jq -r '.metadata | .artist + \" -  \" + .title'", function(stdout)
		-- Remove all lines after the first one
		stdout = stdout:gsub("\n.*", "")
		if stdout ~= "" and stdout ~= " - " then
			title:set_text(stdout)
		else
			title:set_text("Not playing")
		end
	end)
end

title:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		awful.spawn.with_shell("mpc toggle")
	end
end)

gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = daemon,
})

-- Put the title in a container to allow for scrolling when the text is too
-- long (like this comment :-)).
local scrolling_title = wibox.widget({
	layout = wibox.container.scroll.horizontal,
	max_size = 300,
	step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
	speed = 100,
	title,
})

scrolling_title:set_fps(60)

local main = wibox.widget({
	icon,
	scrolling_title,
	layout = wibox.layout.fixed.horizontal,
})

return main
