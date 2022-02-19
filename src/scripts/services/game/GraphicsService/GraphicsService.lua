local App = require('src.app')

local GraphicsConfig = App.config.graphics
local UISetsConfig = App.config.ui_sets_configs

--- @class GraphicsService
local GraphicsService = class('GraphicsService')

function GraphicsService:initialize()
    self.ui_key = App.config.ui.default_ui
end

function GraphicsService:get_ui_key()
    return self.ui_key
end

function GraphicsService:get_pack_icon(index)
    return string.format(GraphicsConfig.pack_icon, self.ui_key, index)
end

function GraphicsService:get_block_icon(index)
    return string.format(GraphicsConfig.block_icon, self.ui_key, index)
end

function GraphicsService:get_ui_config()
    return UISetsConfig[self.ui_key]
end

return GraphicsService
