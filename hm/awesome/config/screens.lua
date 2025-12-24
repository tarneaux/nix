local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local bar = require("bar.bar")

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", beautiful.set_wallpaper)

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	-- awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	-- awful.layout.suit.tile.bottom,
	-- awful.layout.suit.tile.top,
	awful.layout.suit.fair,
	-- awful.layout.suit.fair.horizontal,
	-- awful.layout.suit.spiral,
	-- awful.layout.suit.spiral.dwindle,
	-- awful.layout.suit.max,
	-- awful.layout.suit.max.fullscreen,
	-- awful.layout.suit.magnifier,
	-- awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
}

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	beautiful.set_wallpaper(s)

	bar(s)

	local tag_list = {}
	for _, i in ipairs({ "a", "r", "s", "t", "d", "h" }) do
		for _, j in ipairs({ "1", "2", "3", "4", "5", "6" }) do
			table.insert(tag_list, i .. j)
		end
	end

	-- Each screen has its own tag table.
	awful.tag(tag_list, s, awful.layout.layouts[1])
end)
