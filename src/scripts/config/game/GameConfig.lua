local GameConfig = {}

GameConfig.energy = {
    recovery_time = 1200,
    recovery_count = 5,
    max_count = 32,
    level_reward = 1,
    game_cost = 2,
    life_cost = 2,
    restart_cost = 2
}

GameConfig.balls = {
    rel_size = 0.05,
    min_scale = 0.3,
    speed = {
        start = vmath.vector3(400, 400, 0),
        min = vmath.vector3(100, 100, 0),
        max = vmath.vector3(480, 480, 0),
        delta_speed = vmath.vector3(5, 5, 0)
    },
    start_rel_pos = vmath.vector3(0.5, 0.2, 0),
    rotation = {
        angle = 360,
        duration = 2
    }
}

GameConfig.platform = {
    start_rel_pos = vmath.vector3(0.5, 0.1, 0),
    scale = {
        start = 0.45,
        min = 0.4,
        max = 0.6
    },
    min_dx = 10,
    moving_duration = {
        min = 0.03,
        start = 0.05,
        max = 1
    },
    scaling_duration = 0.07,
    click_area = {
        rel_start = vmath.vector3(0, 0, 0),
        rel_end = vmath.vector3(1, 0.87, 0)
    }
}

GameConfig.blocks = {
    top_margin = 0.15,
    side_margin = 0.05,
    gap = 0.2,
    sprite_falling_duration = 1,
    destroy_granite = false
}

GameConfig.losing_zone = {
    bottom_margin = 0
}

GameConfig.walls = {
    wall_left = {
        rel_pos = vmath.vector3(0, 0.4, 0)
    },
    wall_top = {
        rel_pos = vmath.vector3(0.5, 0.8, 0)
    },
    wall_right = {
        rel_pos = vmath.vector3(1, 0.4, 0)
    }
}

return GameConfig
