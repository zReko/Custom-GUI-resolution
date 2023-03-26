local res_table = {
	{640,360},
	{960,540},
	{1280,720},
	{1600,900},
	{1920,1080},
	{2560,1440},
	{3840,2160},
}
local settings_table = {}
local settings_table_loc = {}
for i, v in pairs(res_table) do
	local res = "customGUIres_item_" .. v[1] .. "x" .. v[2]
	table.insert(settings_table,res)
	settings_table_loc[res] = v[1] .. "x" .. v[2]
end

if not customGUIres then
    customGUIres = {}
	customGUIres.mod_path = ModPath
	customGUIres.save_path = SavePath
	customGUIres.settings = {
		res_id = 3
	}
    function customGUIres:save()
		local file = io.open(self.save_path .. "customGUiRes.txt", "w+")
		if file then
			file:write(json.encode(self.settings))
			file:close()
		end
	end
	function customGUIres:load()
		local file = io.open(self.save_path .. "customGUiRes.txt", "r")
		if file then
			local data = json.decode(file:read("*all")) or {}
			file:close()
			for k, v in pairs(data) do
				self.settings[k] = v
			end
		end
	end
end
customGUIres:load()
local menu_id_main = "CustomGUIres"
Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInitCustomGUIres", function(loc)
	loc:load_localization_file(customGUIres.mod_path .. "loc/english.txt", false)
	loc:add_localized_strings(settings_table_loc)
end)
Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenusCustomGUIres", function(menu_manager, nodes)
	MenuHelper:NewMenu(menu_id_main)
end)
Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenusCustomGUIres", function(menu_manager, nodes)
	MenuCallbackHandler.save_new_res = function(self, item)
		customGUIres.settings[item:name()] = item:value()
		customGUIres:save()
	end
	MenuHelper:AddMultipleChoice({
		id = "res_id",
		title = "CustomGUIres_title",
		desc = "CustomGUIres_desc",
		callback = "save_new_res",
		value = customGUIres.settings.res_id,
		items = settings_table,
		menu_id = menu_id_main,
		priority = 50
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenusCustomGUIres", function(menu_manager, nodes)
	nodes[menu_id_main] = MenuHelper:BuildMenu(menu_id_main, {area_bg = "half"})
	MenuHelper:AddMenuItem(nodes["blt_options"], menu_id_main, "CustomGUIres_main_title")
end)
