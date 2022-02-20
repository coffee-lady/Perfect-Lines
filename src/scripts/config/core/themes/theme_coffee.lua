local CoffeeTheme = {}

CoffeeTheme.game_scene = {
    root = {bg = '2C2721', points = 'FFFFFF', tools = 'FFFFFF'},
    user = {
        primary = {bg = 'EED6C4', stroke = 'B40101', icon = 'B40101', text = 'FFFFFF'},
        authorized = {bg = 'EED6C4', stroke = 'EED6C4', icon = 'FFFFFF', text = 'FFFFFF'},
    },
    game_point = {
        primary = {icon = '856D46'},
        start = {icon = 'EED6C4', stroke = 'EED6C4'},
        finish = {icon = '856D46', stroke = '483434'},
        disabled = {icon = '443D33'},
    },
    line_first = {line = 'EED6C4'},
    line_second = {line = 'E5E5E5'},
}

return CoffeeTheme
