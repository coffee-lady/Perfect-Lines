local Math = {}

local SMALL_VALUE = 1 / 1000000
local EPSILON = 0.0001
local EPSILON_APROXIMATELY = EPSILON * 8

Math.INFINITY = math.huge

function Math.clamp(val, a, b)
    if val < a then
        return a
    end
    if val > b then
        return b
    end

    return val
end

function Math.clamp01(val)
    return Math.clamp(val, 0, 1)
end

function Math.sign(val)
    if val == 0 then
        return 0
    end
    if val > 0 then
        return 1
    end

    return -1
end

function Math.approximately(a, b)
    return math.abs(b - a) < math.max(SMALL_VALUE * math.max(math.abs(a), math.abs(b)), EPSILON_APROXIMATELY)
end

function Math.lerp(a, b, t)
    return a + (b - a) * Math.clamp01(t)
end

function Math.lerp_unclamped(a, b, t)
    return a + (b - a) * t
end

function Math.round(value)
    return math.floor(value + 0.5)
end

function Math.smooth_damp(current, target, currentVelocity, smooth_time, maxSpeed, deltaTime)
    smooth_time = math.max(0.0001, smooth_time)
    local num1 = 2 / smooth_time
    local num2 = num1 * deltaTime
    local num3 = (1.0 / (1.0 + num2 + 0.479999989271164 * num2 * num2 + 0.234999999403954 * num2 * num2 * num2))
    local num4 = current - target
    local num5 = target
    local max = maxSpeed * smooth_time
    local num6 = Math.clamp(num4, -max, max)
    target = current - num6
    local num7 = (currentVelocity + num1 * num6) * deltaTime
    currentVelocity = (currentVelocity - num1 * num7) * num3
    local num8 = target + (num6 + num7) * num3

    local value_a = num5 - current > 0.0
    local value_b = num8 > num5

    if value_a == value_b then
        num8 = num5;
        currentVelocity = (num8 - num5) / deltaTime
    end

    return num8, currentVelocity
end

function Math.circular_position(i, size)
    if size < 1 then
        return 0
    end

    if i < 0 then
        return size - 1 + (i + 1) % size
    end

    return i % size
end

function Math.random(min, max)
    return math.random() * (max - min) + min
end

function Math.random_arr(arr)
    return math.random() * (arr[2] - arr[1]) + arr[1]
end

function Math.random_with_weights(arr)
    local total_weight = 0
    local current_weight = 0

    for _, item in pairs(arr) do
        total_weight = total_weight + item.weight
    end

    local random_weight = math.floor(math.random() * total_weight)

    for _, item in pairs(arr) do
        current_weight = current_weight + item.weight

        if current_weight >= random_weight then
            return item
        end
    end
end

function Math.is_point_in_segment(point, start_coord, end_coord)
    return point >= start_coord and point <= end_coord or point <= start_coord and point >= end_coord
end

function Math.vlength(start_coords, end_coords)
    local dx = start_coords.x - end_coords.x
    local dy = start_coords.y - end_coords.y
    return math.sqrt(dx * dx + dy * dy)
end

function Math.vlength_xy(start_x, start_y, end_x, end_y)
    local dx = start_x - end_x
    local dy = start_y - end_y
    return math.sqrt(dx * dx + dy * dy)
end

function Math.v3_hypotenuse(vector)
    return math.sqrt(vector.x * vector.x + vector.y * vector.y)
end

function Math.hypotenuse(x, y)
    return math.sqrt(x * x + y * y)
end

function Math.get_2d_pos_from_1d(pos, dimension)
    local i = math.ceil(pos / dimension)
    local j = pos - (i - 1) * dimension

    return i, j
end

function Math.get_cycled_2d_pos(i, j, dimensions)
    local di, dj

    if type(dimensions) == 'number' then
        di, dj = dimensions, dimensions
    else
        di, dj = dimensions.i, dimensions.j
    end

    if i <= 0 then
        i = di - math.abs(i)
    end

    if j <= 0 then
        j = dj - math.abs(j)
    end

    if i > 0 and i <= di and j > 0 and j <= dj then
        return i, j
    end

    if i > di then
        i = i - di
    end

    if j > dj then
        j = j - dj
    end

    return i, j
end

function Math.get_pos_in_grid(i, j, elem_size)
    local pos = vmath.vector3()

    if type(elem_size) == 'number' then
        pos.x = (j - 1) * elem_size + elem_size / 2
        pos.y = (i - 1) * elem_size + elem_size / 2
    else
        pos.x = (j - 1) * elem_size.x + elem_size.x / 2
        pos.y = (i - 1) * elem_size.y + elem_size.y / 2
    end

    return pos
end

function Math.get_point_on_circle(angle, radius, circle_rotation)
    local pos = vmath.vector3()
    circle_rotation = circle_rotation or 0

    pos.x = math.cos(math.rad(angle - circle_rotation)) * radius
    pos.y = math.sin(math.rad(angle + circle_rotation)) * radius

    return pos
end

function Math.generate_circle_positions(radius, count)
    local angle = math.pi * 2 / count
    local points = {}

    for i = 1, count do
        points[i] = Math.get_circle_coord(i * angle, radius)
    end

    return points
end

function Math.is_point_in_vector(point, start_coord, end_coord)
    return point >= start_coord and point <= end_coord
end

function Math.is_point_in_plane(point, start_coords, end_coords)
    local is_in_x = Math.is_point_in_vector(point.x, start_coords.x, end_coords.x)
    local is_in_y = Math.is_point_in_vector(point.y, start_coords.y, end_coords.y)
    return is_in_x and is_in_y
end

function Math.point_in_bounds(point, start_coords, end_coords)
    point = vmath.vector3(point.x, point.y, point.z)
    point.x = math.min(math.max(point.x, start_coords.x), end_coords.x)
    point.y = math.min(math.max(point.y, start_coords.y), end_coords.y)
    return point
end

return Math
