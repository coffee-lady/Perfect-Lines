local M = {}

M.segments = {}
M.stored_segments = {}

local bezier_cubic
local bezier_quad
local line

function M.init(bezier)
    bezier_cubic = bezier.bezier_qubic
    bezier_quad = bezier.bezier
    line = bezier.draw_line
end

local function vec_array_eq(a, b)
    if #a ~= #b then
        return false
    end
    for i = 1, #a do
        if a[i].x ~= b[i].x then
            return false
        end
        if a[i].y ~= b[i].y then
            return false
        end
    end
    return true
end

function M.reset()
    M.stored_segments = M.segments
    M.segments = {}
end

local function get_stored_segment(...)
    local args = {...}
    for i, segment in pairs(M.stored_segments) do
        if vec_array_eq(segment.args, args) then
            return segment
        end
    end
    return nil
end

local function append_segment(segment)
    M.segments[#M.segments + 1] = segment
end

local function create_segment(...)
    local seg = {
        points = {},
        args = {...},
    }
    append_segment(seg)
    return seg
end

function M.draw_line(from, to)
    local segment = get_stored_segment(from, to)

    if segment then
        append_segment(segment)
        return
    end

    segment = create_segment(from, to)
    segment.points = line(from, to, segment.points)
end

function M.draw_bezier_cube(from, control1, control2, to)
    local segment = get_stored_segment(from, control1, control2, to)
    if segment then
        append_segment(segment)
        return
    end

    segment = create_segment(from, control1, control2, to)
    segment.points = bezier_cubic(from, control1, control2, to, segment.points)
end

function M.draw_bezier_quad(from, control, to)
    local segment = get_stored_segment(from, control, to)

    if segment then
        append_segment(segment)
        return
    end

    segment = create_segment(from, control, to)

    segment.points = bezier_quad(from, control, to, segment.points)
end

return M
