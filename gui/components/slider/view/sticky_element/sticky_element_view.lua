local StickyElementView = class('StickyElementView')

StickyElementView.MAIN_COORDINATE = {
    x = 'x',
    y = 'y',
}

function StickyElementView:initialize(nodes, params)
    self.nodes = nodes
    self.scroll_index = params.scroll_index
    self.main_coord = params.main_coord
    self.min_axis_pos = params.min_axis
    self.max_axis_pos = params.max_axis
end

function StickyElementView:update_pos(pos)
    if pos[self.main_coord] < self.min_axis_pos then
        self:set_min_pos()
        return
    end

    if pos[self.main_coord] > self.max_axis_pos then
        self:set_max_pos()
        return
    end

    self:_hide_top_fade()
    self:_hide_bottom_fade()
    self.nodes.container:set_pos(pos)
end

function StickyElementView:set_max_pos()
    local pos = vmath.vector3()
    pos[self.main_coord] = self.max_axis_pos

    self:_hide_top_fade()
    self:_show_bottom_fade()
    self.nodes.container:set_pos(pos)
end

function StickyElementView:set_min_pos()
    local pos = vmath.vector3()
    pos[self.main_coord] = self.min_axis_pos

    self:_show_top_fade()
    self:_hide_bottom_fade()
    self.nodes.container:set_pos(pos)
end

function StickyElementView:_show_top_fade()
    if self.nodes.fade_top then
        self.nodes.fade_top:set_enabled(true)
    end
end

function StickyElementView:_show_bottom_fade()
    if self.nodes.fade_bottom then
        self.nodes.fade_bottom:set_enabled(true)
    end
end

function StickyElementView:_hide_top_fade()
    if self.nodes.fade_top then
        self.nodes.fade_top:set_enabled(false)
    end
end

function StickyElementView:_hide_bottom_fade()
    if self.nodes.fade_bottom then
        self.nodes.fade_bottom:set_enabled(false)
    end
end

return StickyElementView
