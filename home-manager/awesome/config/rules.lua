local awful = require("awful")
local beautiful = require("beautiful")


-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = ClientKeys,
                     buttons = ClientButtons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          --"Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- place conky in background on primary screen
    { rule = { class = "conky" },
      properties = { focusable = false, screen = function() return screen.primary end,
        placement = awful.placement.restore, new_tag = { hide = true, volatile = true }},
      callback = function()
        if not awful.rules.conky_signals_connected then
          local function conky_restart()
            awful.spawn("killall -SIGUSR1 conky", false)
          end

          -- restart conky when a screen is removed or its geometry changes, or when awesome restarts
          screen.connect_signal("property::geometry", conky_restart)
          screen.connect_signal("removed", conky_restart)
          awesome.connect_signal("exit", conky_restart)

          awful.rules.conky_signals_connected = true
        end
      end
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- This is just an example.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
