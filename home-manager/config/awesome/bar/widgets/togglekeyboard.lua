local internal_keyboard = "AT Translated Set 2 keyboard"

-- Kanata (which rebinds some keys) creates a new virtual device. Since I just
-- have it enabled on the internal keyboard, I can just disable the kanata
-- virtual device to effectively block the internal keyboard.
-- local internal_keyboard = "kanata"

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local widget = wibox.widget.textbox()

local id = 'xinput list | grep "' .. internal_keyboard .. '" | grep -E "(floating slave|keyboard)" | sed -n "s/.*id=\\([0-9]*\\).*/\\1/p"'

local function get_enabled (callback)
    awful.spawn.easy_async_with_shell(id .. ' | xargs xinput list-props | grep "Device Enabled" | awk \'{print $4}\'', function (stdout)
        callback(stdout == "1\n")
    end)
end

local function daemon ()
    get_enabled(function(status)
        if status then
            widget:set_text("  on")
        else
            widget:set_text("  off")
        end
    end)
end

local function toggle ()
    get_enabled(function(status)
        local new
        if status then
            new = 0
        else
            new = 1
        end

        awful.spawn.easy_async_with_shell(id .. ' | xargs -I {} xinput set-prop {} "Device Enabled" ' .. new, function()
            daemon()
        end)
    end)
end

widget:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
        toggle()
    end
end)

gears.timer {
    timeout = 1,
    call_now = true,
    autostart = true,
    callback = daemon
}

return widget
