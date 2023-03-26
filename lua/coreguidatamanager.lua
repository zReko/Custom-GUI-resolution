core:module("CoreGuiDataManager")
local res_table = {
	{640,360},
	{960,540},
	{1280,720},
	{1600,900},
	{1920,1080},
	{2560,1440},
	{3840,2160},
}
local settings = {
	res_id = 3
}
local file = io.open(SavePath .. "customGUiRes.txt", "r")
if file then
	local data = json.decode(file:read("*all")) or {}
	file:close()
	for k, v in pairs(data) do
		settings[k] = v
	end
end
local base_res = {
	x = res_table[settings.res_id or 3][1],
	y = res_table[settings.res_id or 3][2]
}
function GuiDataManager:get_base_res()
	return base_res.x, base_res.y
end
function GuiDataManager:_setup_workspace_data()
	self._saferect_data = {}
	self._corner_saferect_data = {}
	self._fullrect_data = {}
	self._fullrect_16_9_data = {}
	self._fullrect_1280_data = {}
	self._corner_saferect_1280_data = {}
	local safe_rect = self:_get_safe_rect_pixels()
	local scaled_size = self:scaled_size()
	local res = self._static_resolution or RenderSettings.resolution
	local w = scaled_size.width
	local h = scaled_size.height
	local sh = math.min(safe_rect.height, safe_rect.width / (w / h))
	local sw = math.min(safe_rect.width, safe_rect.height * w / h)
	local x = res.x / 2 - sh * w / h / 2
	local y = res.y / 2 - sw / (w / h) / 2
	self._safe_x = x
	self._safe_y = y
	self._saferect_data.w = w
	self._saferect_data.h = h
	self._saferect_data.width = self._saferect_data.w
	self._saferect_data.height = self._saferect_data.h
	self._saferect_data.x = x
	self._saferect_data.y = y
	self._saferect_data.on_screen_width = sw
	local h_c = w / (safe_rect.width / safe_rect.height)
	h = math.max(h, h_c)
	local w_c = h_c / h
	w = math.max(w, w / w_c)
	self._corner_saferect_data.w = w
	self._corner_saferect_data.h = h
	self._corner_saferect_data.width = self._corner_saferect_data.w
	self._corner_saferect_data.height = self._corner_saferect_data.h
	self._corner_saferect_data.x = safe_rect.x
	self._corner_saferect_data.y = safe_rect.y
	self._corner_saferect_data.on_screen_width = safe_rect.width
	sh = base_res.x / self:_aspect_ratio()
	h = math.max(base_res.y, sh)
	sw = sh / h
	w = math.max(base_res.x, base_res.x / sw)
	self._fullrect_data.w = w
	self._fullrect_data.h = h
	self._fullrect_data.width = self._fullrect_data.w
	self._fullrect_data.height = self._fullrect_data.h
	self._fullrect_data.x = 0
	self._fullrect_data.y = 0
	self._fullrect_data.on_screen_width = res.x
	self._fullrect_data.convert_x = math.floor((w - self._saferect_data.w) / 2)
	self._fullrect_data.convert_y = (h - scaled_size.height) / 2
	self._fullrect_data.corner_convert_x = math.floor((self._fullrect_data.width - self._corner_saferect_data.width) / 2)
	self._fullrect_data.corner_convert_y = math.floor((self._fullrect_data.height - self._corner_saferect_data.height) / 2)
	w = base_res.x
	h = base_res.y
	sh = math.min(res.y, res.x / (w / h))
	sw = math.min(res.x, res.y * w / h)
	x = res.x / 2 - sh * w / h / 2
	y = res.y / 2 - sw / (w / h) / 2
	self._fullrect_16_9_data.w = w
	self._fullrect_16_9_data.h = h
	self._fullrect_16_9_data.width = self._fullrect_16_9_data.w
	self._fullrect_16_9_data.height = self._fullrect_16_9_data.h
	self._fullrect_16_9_data.x = x
	self._fullrect_16_9_data.y = y
	self._fullrect_16_9_data.on_screen_width = sw
	self._fullrect_16_9_data.convert_x = math.floor((self._fullrect_16_9_data.w - self._saferect_data.w) / 2)
	self._fullrect_16_9_data.convert_y = (self._fullrect_16_9_data.h - self._saferect_data.h) / 2
	local aspect = math.clamp(res.x / res.y, 1, 1.7777777777777777)
	w = base_res.x
	h = base_res.x / aspect
	sw = math.min(res.x, res.y * aspect)
	sh = sw / w * h
	x = (res.x - sw) / 2
	y = (res.y - sh) / 2
	self._fullrect_1280_data.w = w
	self._fullrect_1280_data.h = h
	self._fullrect_1280_data.width = self._fullrect_1280_data.w
	self._fullrect_1280_data.height = self._fullrect_1280_data.h
	self._fullrect_1280_data.x = x
	self._fullrect_1280_data.y = y
	self._fullrect_1280_data.on_screen_width = sw
	self._fullrect_1280_data.sw = sw
	self._fullrect_1280_data.sh = sh
	self._fullrect_1280_data.aspect = aspect
	self._fullrect_1280_data.convert_x = math.floor((self._fullrect_data.w - self._fullrect_1280_data.w) / 2)
	self._fullrect_1280_data.convert_y = math.floor((self._fullrect_data.h - self._fullrect_1280_data.h) / 2)
	w = scaled_size.width
	h = scaled_size.width / aspect
	sw = math.min(safe_rect.width, safe_rect.height * aspect)
	sh = sw / w * h
	x = (res.x - sw) / 2
	y = (res.y - sh) / 2
	self._corner_saferect_1280_data.w = w
	self._corner_saferect_1280_data.h = h
	self._corner_saferect_1280_data.width = self._corner_saferect_1280_data.w
	self._corner_saferect_1280_data.height = self._corner_saferect_1280_data.h
	self._corner_saferect_1280_data.x = x
	self._corner_saferect_1280_data.y = y
	self._corner_saferect_1280_data.on_screen_width = sw
end
function GuiDataManager:scaled_size()
	local w = math.round(self:_get_safe_rect().width * base_res.x)
	local h = math.round(self:_get_safe_rect().height * base_res.y)
	return {
		x = 0,
		y = 0,
		width = w,
		height = h
	}
end