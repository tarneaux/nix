local awful = require("awful")
local beautiful = require("beautiful")

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	if not awesome.startup then
		awful.client.setslave(c)
	end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

-- Prevent clients from being maximized (e.g. inkscape starts maximized)
client.connect_signal("property::maximized", function(c)
	if c.maximized then
		c.maximized = false
	end
end)

-- Handle clients requesting focus correctly
client.connect_signal("request::activate", function(c)
	local tags = c:tags()
	if #tags == 1 then
		tags[1]:view_only()
	end
	c.minimized = false
end)

-- Work around clients being moved to different tags when screens are changed.
-- See https://github.com/awesomeWM/awesome/issues/1382
screen.connect_signal("added", awesome.restart)
screen.connect_signal("removed", awesome.restart)
