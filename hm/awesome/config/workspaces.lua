local awful = require("awful")

local workspaces = {}

workspaces.get_tag_table = function(screen)
	local res = {}
	for _, value in pairs(screen.tags) do
		local ws, tagname = string.match(value.name, "^" .. "(.*)" .. "([0-9])$")
		if ws ~= nil then
			if res[ws] == nil then
				res[ws] = {}
			end
			res[ws][tagname] = value
		end
	end
	return res
end

workspaces.get_workspace_tags = function(screen)
	return workspaces.get_tag_table(screen)[workspaces.current(screen)]
end

local function initialize_tpw_table_for_ws(screen, workspace_name)
	screen.last_tag_per_workspace[workspace_name] = "1"

	for tk, tv in pairs(workspaces.get_tag_table(screen)[workspace_name]) do
		if #tv:clients() > 0 then
			screen.last_tag_per_workspace[workspace_name] = tk
			break
		end
	end
end

local function initialize_tpw_table(screen)
	screen.last_tag_per_workspace = {}
	for wk, _ in pairs(workspaces.get_tag_table(screen)) do
		initialize_tpw_table_for_ws(screen, wk)
	end
end

workspaces.get_last_tag_of_ws = function(screen, ws)
	if screen.last_tag_per_workspace == nil then
		initialize_tpw_table(screen)
	end

	if #screen.selected_tag:clients() > 0 then
		screen.last_tag_per_workspace[workspaces.current(screen)] = workspaces.current_tag_clean(screen)
	else
		initialize_tpw_table_for_ws(screen, workspaces.current(screen))
	end

	return workspaces.get_tag_table(screen)[ws][screen.last_tag_per_workspace[ws]]
end

workspaces.current = function(screen)
	return string.match(screen.selected_tag.name, "^(.)[0-9]$")
end

workspaces.current_tag_clean = function(screen)
	return string.match(screen.selected_tag.name, "^.([0-9])$")
end

function workspaces.taglist_filter(t)
	return string.match(t.name, "^" .. workspaces.current(awful.screen.focused()) .. "([0-9])$") ~= nil
end

return workspaces
