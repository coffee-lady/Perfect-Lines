local ScreensConstants = {bootstrap = {container = 'container'}}

ScreensConstants.game_scene = {
    root = 'root',
    user = {
        container = 'user/container',
        icon_bg = 'user/icon_bg',
        icon = 'user/icon',
        stroke = 'user/stroke',
        text = 'user/text',
    },
    points = {container = 'points/container', icon = 'points/icon', text = 'points/text'},
    game_point = {container = 'game_point/container', icon = 'game_point/icon', highlight = 'game_point/highlight'},
    tool_hint = {container = 'tool_hint/container', icon = 'tool_hint/icon', text = 'tool_hint/text'},
    tool_clear = {container = 'tool_clear/container', icon = 'tool_clear/icon', text = 'tool_clear/text'},
}

return ScreensConstants
