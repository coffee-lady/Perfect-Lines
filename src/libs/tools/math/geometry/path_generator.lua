local M = {}

function M.radial_path(center, radius, dot_count, start_angle, delta_angle)
    start_angle = start_angle or 0
    delta_angle = delta_angle or 360

    start_angle = math.rad(start_angle)
    delta_angle = math.rad(delta_angle)

    local angle_step = delta_angle / (dot_count - 1)
    local res = {}

    local cx = center.x
    local cy = center.y
    local cz = center.z
    for _ = 1, dot_count do
        local x = cx + math.cos(start_angle) * radius
        local y = cy + math.sin(start_angle) * radius
        table.insert(res, vmath.vector3(x, y, cz))
        start_angle = start_angle + angle_step
    end

    return res
end

function M.rand_circle_pos(center, radius)
    local angle_rand = math.random() * math.pi * 2
    local pos = vmath.vector3(center.x + math.cos(angle_rand) * radius,
                              center.y + math.sin(angle_rand) * radius, center.z)
    return pos
end

function M.rand_circle_pos_in(center, radius_min, radius_max)
    local radius_rand = math.random(radius_min, radius_max)
    return M.rand_circle_pos(center, radius_rand)
end

return M
