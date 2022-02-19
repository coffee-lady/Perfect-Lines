local M = {}

M.DEFAULT_Z = 1

function M.bezier(from, control, to, point_count, path)
    local z = from.z
    local points = path or {}
    local x0 = from.x
    local y0 = from.y
    local xc = control.x
    local yc = control.y
    local x1 = to.x
    local y1 = to.y

    local step = 1 / (point_count - 1)
    local t = 0

    local path_count = #points

    for _ = 1, point_count do
        local oneMinusT = 1 - t
        local opt1 = oneMinusT * oneMinusT
        local opt2 = 2 * t * oneMinusT
        local opt3 = t * t
        local xt = (opt1 * x0) + (opt2 * xc) + (opt3 * x1)
        local yt = (opt1 * y0) + (opt2 * yc) + (opt3 * y1)

        local next = vmath.vector3(xt, yt, z)
        path_count = path_count + 1
        points[path_count] = next
        t = t + step
    end

    return points
end

function M.random_bezier_path(from, to, points_count)
    local minX, maxX = math.min(from.x, to.x), math.max(from.x, to.x)
    local control = vmath.vector3()
    control.x = minX + (maxX - minX) * math.random()
    control.y = (from.y + to.y) / 2

    return M.bezier(from, control, to, points_count)
end

function M.bezier_qubic(from, control1, control2, to, point_count, path)
    local points = path or {}

    local x0 = from.x
    local y0 = from.y
    local x1 = control1.x
    local y1 = control1.y
    local x2 = control2.x
    local y2 = control2.y
    local x3 = to.x
    local y3 = to.y

    local step = 1 / (point_count - 1)
    local t = 0

    local path_count = #path

    for i = 1, point_count do
        local oneMinusT = 1 - t
        local sqOneMinusT = oneMinusT * oneMinusT
        local firstParam = oneMinusT * sqOneMinusT
        local secondParam = sqOneMinusT * t * 3
        local thirdParam = t * t * oneMinusT * 3
        local fourthParam = t * t * t

        local xt = firstParam * x0 + secondParam * x1 + thirdParam * x2 + fourthParam * x3
        local yt = firstParam * y0 + secondParam * y1 + thirdParam * y2 + fourthParam * y3
        local next = vmath.vector3(xt, yt, M.DEFAULT_Z)
        path_count = path_count + 1
        path[path_count] = next
        t = t + step
    end

    return points
end

return M
