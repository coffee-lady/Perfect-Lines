local AbstractButton = require('gui.controls.abstract_button.abstract_button')
local Extensions = require('gui.extensions.extensions')
local Components = require('gui.components.components')
local Controls = require('gui.controls.controls')
local Constants = require('gui.constants.gui_constants')
local Transitions = require('gui.transitions.transitions')

local GUI = {}

for key, value in pairs(Constants) do
    GUI[key] = value
end

GUI.BUTTON_DEFAULT = AbstractButton.BUTTON_DEFAULT
GUI.BUTTON_LINK = AbstractButton.BUTTON_LINK
GUI.BUTTON_SLIDER = AbstractButton.BUTTON_SLIDER
GUI.BUTTON_CLOSE = AbstractButton.BUTTON_CLOSE

GUI.BUTTON_CLICKED = AbstractButton.BUTTON_CLICKED

GUI.SubscribedButton = Controls.SubscribedButton
GUI.ButtonsMenu = Controls.ButtonsMenu
GUI.SubscribedLink = Controls.SubscribedLink
GUI.LinksMenu = Controls.LinksMenu
GUI.FlowButtonsMenu = Controls.FlowButtonsMenu
GUI.Node = require('gui.core.nodes.node.node')
GUI.BoxNode = require('gui.core.nodes.box_node.box_node')
GUI.PieNode = require('gui.core.nodes.pie_node.pie_node')
GUI.ParticlefxNode = require('gui.core.nodes.particlefx_node.particlefx_node')
GUI.TextNode = require('gui.core.nodes.text_node.text_node')
GUI.NodesList = require('gui.core.nodes.nodes_list.nodes_list')
GUI.NodeFactory = require('gui.core.node_factory.node_factory')
GUI.ThemeNode = require('gui.core.theme_objects.ThemeNode')
GUI.StaticThemeNode = require('gui.core.theme_objects.StaticThemeNode')
GUI.ThemeMap = require('gui.core.theme_objects.ThemeMap')
GUI.layouts = require('gui.core.layouts.layouts')
GUI.Texture = require('gui.core.texture.texture')
GUI.FancyScroll = require('gui.fancy_scroll.fancy_scroll')
GUI.DragAndDrop = require('gui.drag_and_drop.drag_and_drop')
GUI.SceneLocalization = require('gui.localization.SceneLocalization')

GUI.LocalizationMap = require('gui.localization.localization_map')
GUI.Widget = require('gui.widget.widget')

GUI.RichTextNode = Extensions.RichTextNode
GUI.RichLocalizationMap = Extensions.RichLocalizationMap

GUI.Slider = Components.Slider
GUI.Checkbox = Components.Checkbox
GUI.Switch = Components.Switch
GUI.RadioButtonsGroup = Components.RadioButtonsGroup
GUI.SWITCH_TOGGLED = GUI.Switch.SWITCH_TOGGLED
GUI.RADIO_BUTTON_SELECTED = GUI.RadioButtonsGroup.RADIO_BUTTON_SELECTED
GUI.Transitions = Transitions

return GUI
