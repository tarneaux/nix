local awful = require("awful")
local gears = require("gears")
local lain = require("lain")
require("awful.hotkeys_popup.keys")

ModKey = "Mod4"

local previous_layout = nil

local function termquake(name, command)
	return lain.util.quake({
		app = "alacritty --class " .. name,
		argname = "--title %s -e " .. command,
		followtag = true,
		height = 0.8,
		width = 0.8,
		vert = "center",
		horiz = "center",
		border = 2,
		name = name,
		settings = function(c)
			c.sticky = true
		end,
	})
end

local music_quake = termquake("MusicQuake", "rmpc")
local space_quake = termquake("SpaceQuake", "zsh -c 'tmw ~/space \"nvim todo.md\"'")
local irc_quake = termquake("IrcQuake", "zsh -c 'tmux new-session -A -s irc wgx weechat'")

local globalkeys = gears.table.join(
	-- Reload awesome
	awful.key({ ModKey }, "q", awesome.restart),

	---------------------------
	-- Start other processes --
	---------------------------

	-- Menu
	awful.key({ ModKey }, "p", function()
		awful.spawn.with_shell("rofi -show drun")
	end),

	-- Various apps
	awful.key({ ModKey }, "b", function()
		awful.spawn.with_shell("qprofile-menu")
	end),
	awful.key({ ModKey }, "Return", function()
		awful.spawn.with_shell(Terminal)
	end),
	awful.key({ ModKey, "Ctrl" }, "Return", function()
		awful.spawn.with_shell(TerminalCmd .. "tmw")
	end),
	awful.key({ ModKey }, "g", function()
		space_quake:toggle()
	end),
	awful.key({ ModKey }, "v", function()
		irc_quake:toggle()
	end),
	-- Super + / (triboard) or Super + Shift + : (french keyboard)
	awful.key({ ModKey, "Shift" }, "#60", function()
		music_quake:toggle()
	end),

	-- Lock screen
	awful.key({ ModKey }, "z", function()
		awful.spawn.with_shell("lock")
	end),
	-- Blank screen
	awful.key({ ModKey, "Control" }, "z", function()
		awful.spawn.with_shell("xset s activate; sleep 2; xset dpms force standby")
	end),
	-- Power menu
	awful.key({ ModKey, "Control" }, "q", function()
		awful.spawn.with_shell("powermenu")
	end),

	-- Screenshot
	awful.key({ ModKey }, "x", function()
		awful.spawn.with_shell("maim -su | xclip -selection clipboard -t image/png")
	end),

	-- Type in server user password
	awful.key({ ModKey }, "y", function()
		awful.spawn.with_shell("passmenu type")
	end),

	-- Rerun autostart script (and therefore unisond)
	awful.key({ ModKey, "Control" }, "u", function()
		awful.spawn.with_shell("awesomewm-autostart")
	end),

	-----------------------------
	-- Media / brightness keys --
	-----------------------------

	-- Volume control
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.spawn.with_shell("pamixer -i 2")
	end),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.spawn.with_shell("pamixer -d 2")
	end),
	awful.key({}, "XF86AudioMute", function()
		awful.spawn.with_shell("pamixer -t")
	end),

	-- MPD control
	awful.key({}, "XF86AudioNext", function()
		awful.spawn.with_shell("mpc next")
	end),
	awful.key({}, "XF86AudioPrev", function()
		awful.spawn.with_shell("mpc prev")
	end),
	awful.key({}, "XF86AudioPlay", function()
		awful.spawn.with_shell("mpc toggle")
	end),
	awful.key({}, "XF86AudioPause", function()
		awful.spawn.with_shell("mpc toggle")
	end),

	-- Playerctl control
	awful.key({ "Control" }, "XF86AudioNext", function()
		awful.spawn.with_shell("playerctl next")
	end),
	awful.key({ "Control" }, "XF86AudioPrev", function()
		awful.spawn.with_shell("playerctl previous")
	end),
	awful.key({ "Control" }, "XF86AudioPlay", function()
		awful.spawn.with_shell("playerctl play-pause")
	end),
	awful.key({ "Control" }, "XF86AudioPause", function()
		awful.spawn.with_shell("playerctl play-pause")
	end),

	-- Brightness
	awful.key({}, "XF86MonBrightnessDown", function()
		awful.spawn.with_shell("brightnessctl set 10%-")
	end),
	awful.key({}, "XF86MonBrightnessUp", function()
		awful.spawn.with_shell("brightnessctl set +10%")
	end),

	-----------------------------------
	-- Focus and layout manipulation --
	-----------------------------------

	-- (colemak's neio is QWERTY's hjkl.)

	awful.key({ ModKey }, "i", function()
		awful.client.focus.byidx(1)
	end),
	awful.key({ ModKey }, "e", function()
		awful.client.focus.byidx(-1)
	end),
	awful.key({ ModKey, "Shift" }, "i", function()
		awful.client.swap.byidx(1)
	end),
	awful.key({ ModKey, "Shift" }, "e", function()
		awful.client.swap.byidx(-1)
	end),
	awful.key({ ModKey, "Shift" }, "o", function()
		awful.tag.incmwfact(0.05)
	end),
	awful.key({ ModKey, "Shift" }, "n", function()
		awful.tag.incmwfact(-0.05)
	end),
	awful.key({ ModKey }, "n", function()
		awful.tag.incnmaster(1, nil, true)
	end),
	awful.key({ ModKey }, "o", function()
		awful.tag.incnmaster(-1, nil, true)
	end),
	awful.key({ ModKey, "Shift" }, "m", function()
		awful.tag.incncol(1, nil, true)
	end),
	-- Super + Shift + / (triboard) or Super + Shift + , (french keyboard)
	awful.key({ ModKey, "Shift" }, "#58", function()
		awful.tag.incncol(-1, nil, true)
	end),
	awful.key({ ModKey }, ",", function()
		awful.layout.inc(1)
	end),
	awful.key({ ModKey }, "m", function()
		awful.tag.history.restore()
	end),

	-- Toggle maximized layout
	-- This will just crash if you set the default layout to maximized, but else it works well.
	-- Super + . (triboard) or Super + Shift + ; (french keyboard)
	-- Only really reliable on one tag, this could be improved.
	awful.key({ ModKey, "Shift" }, "#59", function()
		local screen = awful.screen.focused()
		local tag = screen.selected_tag
		local current_layout = tag.layout

		local toggled_layout = awful.layout.suit.max

		if current_layout.name == toggled_layout.name then
			awful.layout.set(previous_layout, tag)
		else
			previous_layout = current_layout
			awful.layout.set(toggled_layout, tag)
		end
	end),

	-- Restore last minimized client
	awful.key({ ModKey }, "u", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end)
)

-- Keys for clients (windows)
ClientKeys = gears.table.join(
	-- Toggle fullscreen = no borders, bar, titlebar, or gaps
	awful.key({ ModKey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end),
	-- Close client
	awful.key({ ModKey }, "w", function(c)
		c:kill()
	end),
	-- Toggle floating
	awful.key({ ModKey }, "c", awful.client.floating.toggle),
	-- Toggle maximized
	awful.key({ ModKey, "Shift" }, "f", function(c)
		c.maximized = not c.maximized
	end),
	-- Minimize client
	awful.key({ ModKey }, "l", function(c)
		c.minimized = true
	end)
)

-- Bind all key numbers to tags.
-- Colemak's "arstd" = qwerty's "asdfg"
local tagkeys = { "a", "r", "s", "t", "d", "h" }
for i = 1, 6 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ ModKey }, tagkeys[i], function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end),
		-- Toggle tag display.
		awful.key({ ModKey, "Control" }, tagkeys[i], function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end),
		-- Move client to tag.
		awful.key({ ModKey, "Shift" }, tagkeys[i], function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end),
		-- Toggle tag on focused client.
		awful.key({ ModKey, "Control", "Shift" }, tagkeys[i], function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end)
	)
end

-- Mouse bindings. You shouldn't need to change these.
ClientButtons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ ModKey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ ModKey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- Set keys. Without this line all of this file is useless!
root.keys(globalkeys)
