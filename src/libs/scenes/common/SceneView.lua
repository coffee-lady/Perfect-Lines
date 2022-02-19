local Luject = require('src.libs.luject.luject')

local function safe_resolve(Class, ...)
    if Class then
        return Luject:resolve_class(Class, ...)
    end

    return {}
end

local function call_safe(func, ...)
    if func then
        func(...)
    end
end

--- @class SceneView
local SceneView = class('SceneView')

function SceneView:initialize(UIMaps)
    self.nodes_map = safe_resolve(UIMaps.NodesMap)
    self.nodes = self.nodes_map:get_table()
    self.theme_map = safe_resolve(UIMaps.ThemeMap, self.nodes_map)
    self.localization_map = safe_resolve(UIMaps.LocalizationMap, self.nodes_map)
    self.controls_map = safe_resolve(UIMaps.ControlsMap)
end

function SceneView:final()
    call_safe(self.theme_map.final, self.theme_map)
    call_safe(self.localization_map.final, self.localization_map)
    call_safe(self.controls_map.final, self.controls_map)
end

return SceneView
