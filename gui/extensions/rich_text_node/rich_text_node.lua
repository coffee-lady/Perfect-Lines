local richtext = require('richtext.richtext')

local Array = require('src.libs.tools.types.array.array')

--- @class RichTextNode
local RichTextNode = class('RichTextNode')

RichTextNode.ALIGN_LEFT = richtext.ALIGN_LEFT
RichTextNode.ALIGN_CENTER = richtext.ALIGN_CENTER
RichTextNode.ALIGN_RIGHT = richtext.ALIGN_RIGHT
RichTextNode.ALIGN_JUSTIFY = richtext.ALIGN_JUSTIFY

RichTextNode.VALIGN_TOP = richtext.VALIGN_TOP
RichTextNode.VALIGN_MIDDLE = richtext.VALIGN_MIDDLE
RichTextNode.VALIGN_BOTTOM = richtext.VALIGN_BOTTOM

RichTextNode.DEFAULT_SETTINGS = {}

function RichTextNode:initialize(id, settings)
    -- settings = {
    --     fonts = {
    --         Roboto = {
    --             regular = hash("Roboto-Regular"),
    --             italic = hash("Roboto-Italic"),
    --             bold = hash("Roboto-Bold"),
    --             bold_italic = hash("Roboto-BoldItalic"),
    --         },
    --         Nanum = {
    --             regular = hash("Nanum-Regular"),
    --         },
    --     },
    --     initial_font = "Roboto",
    --     width = 400,
    --     parent = gui.get_node("bg"),
    --     color = vmath.vector4(0.95, 0.95, 1.0, 1.0),
    --     shadow = vmath.vector4(0.0, 0.0, 0.0, 1.0),
    --     align (hash) - One of richtext.ALIGN_LEFT, richtext.ALIGN_CENTER, richtext.ALIGN_RIGHT and richtext.ALIGN_JUSTIFY.
    -- }

    self.target = type(id) == 'string' and gui.get_node(id) or id

    self.settings = settings and Array.copy_1d(settings) or Array.copy_1d(RichTextNode.DEFAULT_SETTINGS)

    self.settings.align = self.settings.align or RichTextNode.ALIGN_CENTER
    self.settings.parent = self.target or RichTextNode.VALIGN_MIDDLE

    if self.settings.combine_words == nil then
        self.settings.combine_words = true
    end
end

function RichTextNode:set_text(text)
    self.text = text
    self:_update_text()
end

function RichTextNode:get_actual_size()
    return self.text_metrics
end

function RichTextNode:get_metrics()
    return self.text_metrics
end

function RichTextNode:set_color(color)
    self.settings.color = color

    if self.text then
        self:_update_text()
    end
end

function RichTextNode:_update_text()
    self.nodes, self.text_metrics = richtext.create(self.text, self.settings.initial_font, self.settings)
end

function RichTextNode.static:set_default_settings(settings)
    RichTextNode.DEFAULT_SETTINGS = settings
end

return RichTextNode
