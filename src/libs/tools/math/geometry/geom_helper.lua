local M = {}

local ANGLE_2PI = math.pi * 2

function M.get_circle_coord(angle, radius, z)
    z = z or 0

    local x = math.sin(angle) * radius
    local y = math.cos(angle) * radius

    return vmath.vector3(x, y, z)
end

function M.get_coord(perc, radius)
    local a = math.pi * 2 * perc
    return M.get_circle_coord(a, radius)
end

function M.generate_circle_positions(radius, button_count)
    local angle = ANGLE_2PI / button_count
    local points = {}

    for i = 1, button_count do
        points[i] = M.get_circle_coord(i * angle, radius)
    end

    return points
end

return M
