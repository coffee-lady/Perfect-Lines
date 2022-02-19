local M = {}

local vmath_length = vmath.length

local function addControlPoints(points, pointFrom, pointControl, pointTo, t)
    local da = vmath_length(pointFrom - pointControl)
    local db = vmath_length(pointTo - pointControl)
    local ds = da + db
    local sc_a = t * da / ds
    local sc_b = t * db / ds

    local w = pointFrom.x - pointTo.x
    local h = pointFrom.y - pointTo.y

    local controlPointFrom = vmath.vector3(pointControl.x + w * sc_a, pointControl.y + h * sc_a, 0)
    local controlPointTo = vmath.vector3(pointControl.x - w * sc_b, pointControl.y - h * sc_b, 0)

    local point_count = #points
    points[point_count + 1] = controlPointFrom
    points[point_count + 2] = controlPointTo
end

function M.drawCurve(drawer, path, t)
    local control_points = {}
    local path_len = #path

    if path_len < 2 then
        return
    end

    for i = 1, path_len - 2 do
        addControlPoints(control_points, path[i], path[i + 1], path[i + 2], t)
    end

    local j = 2
    for i = 2, path_len - 2 do
        drawer.draw_bezier_cube(path[i], control_points[j], control_points[j + 1], path[i + 1])
        j = j + 2
    end

    drawer.draw_bezier_quad(path[1], control_points[1], path[2])

    if path_len > 2 then
        drawer.draw_bezier_quad(path[path_len - 1], control_points[#control_points], path[path_len])
    end

end

return M
