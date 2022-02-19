local EasingsLib = {}

local pow = math.pow
local sin = math.sin
local cos = math.cos
local pi = math.pi
local sqrt = math.sqrt
local abs = math.abs
local asin = math.asin

function EasingsLib.linear(time, start, change, duration)
    return change * time / duration + start
end

function EasingsLib.in_quad(time, start, change, duration)
    time = time / duration
    return change * pow(time, 2) + start
end

function EasingsLib.out_quad(time, start, change, duration)
    time = time / duration
    return -change * time * (time - 2) + start
end

function EasingsLib.in_out_quad(time, start, change, duration)
    time = time / duration * 2
    if time < 1 then
        return change / 2 * pow(time, 2) + start
    else
        return -change / 2 * ((time - 1) * (time - 3) - 1) + start
    end
end

function EasingsLib.out_in_quad(time, start, change, duration)
    if time < duration / 2 then
        return EasingsLib.out_quad(time * 2, start, change / 2, duration)
    else
        return EasingsLib.in_quad((time * 2) - duration, start + change / 2, change / 2, duration)
    end
end

function EasingsLib.in_cubic(time, start, change, duration)
    time = time / duration
    return change * pow(time, 3) + start
end

function EasingsLib.out_cubic(time, start, change, duration)
    time = time / duration - 1
    return change * (pow(time, 3) + 1) + start
end

function EasingsLib.in_out_cubic(time, start, change, duration)
    time = time / duration * 2
    if time < 1 then
        return change / 2 * time * time * time + start
    else
        time = time - 2
        return change / 2 * (time * time * time + 2) + start
    end
end

function EasingsLib.out_in_cubic(time, start, change, duration)
    if time < duration / 2 then
        return EasingsLib.out_cubic(time * 2, start, change / 2, duration)
    else
        return EasingsLib.in_cubic((time * 2) - duration, start + change / 2, change / 2, duration)
    end
end

function EasingsLib.in_quart(time, start, change, duration)
    time = time / duration
    return change * pow(time, 4) + start
end

function EasingsLib.out_quart(time, start, change, duration)
    time = time / duration - 1
    return -change * (pow(time, 4) - 1) + start
end

function EasingsLib.in_out_quart(time, start, change, duration)
    time = time / duration * 2
    if time < 1 then
        return change / 2 * pow(time, 4) + start
    else
        time = time - 2
        return -change / 2 * (pow(time, 4) - 2) + start
    end
end

function EasingsLib.out_in_quart(time, start, change, duration)
    if time < duration / 2 then
        return EasingsLib.out_quart(time * 2, start, change / 2, duration)
    else
        return EasingsLib.in_quart((time * 2) - duration, start + change / 2, change / 2, duration)
    end
end

function EasingsLib.in_quint(time, start, change, duration)
    time = time / duration
    return change * pow(time, 5) + start
end

function EasingsLib.out_quint(time, start, change, duration)
    time = time / duration - 1
    return change * (pow(time, 5) + 1) + start
end

function EasingsLib.in_out_quint(time, start, change, duration)
    time = time / duration * 2
    if time < 1 then
        return change / 2 * pow(time, 5) + start
    else
        time = time - 2
        return change / 2 * (pow(time, 5) + 2) + start
    end
end

function EasingsLib.out_in_quint(time, start, change, duration)
    if time < duration / 2 then
        return EasingsLib.out_quint(time * 2, start, change / 2, duration)
    else
        return EasingsLib.in_quint((time * 2) - duration, start + change / 2, change / 2, duration)
    end
end

function EasingsLib.in_sine(time, start, change, duration)
    return -change * cos(time / duration * (pi / 2)) + change + start
end

function EasingsLib.out_sine(time, start, change, duration)
    return change * sin(time / duration * (pi / 2)) + start
end

function EasingsLib.in_out_sine(time, start, change, duration)
    return -change / 2 * (cos(pi * time / duration) - 1) + start
end

function EasingsLib.out_in_sine(time, start, change, duration)
    if time < duration / 2 then
        return EasingsLib.out_sine(time * 2, start, change / 2, duration)
    else
        return EasingsLib.in_sine((time * 2) - duration, start + change / 2, change / 2, duration)
    end
end

function EasingsLib.in_expo(time, start, change, duration)
    if time == 0 then
        return start
    else
        return change * pow(2, 10 * (time / duration - 1)) + start - change * 0.001
    end
end

function EasingsLib.out_expo(time, start, change, duration)
    if time == duration then
        return start + change
    else
        return change * 1.001 * (-pow(2, -10 * time / duration) + 1) + start
    end
end

function EasingsLib.in_out_expo(time, start, change, duration)
    if time == 0 then
        return start
    end
    if time == duration then
        return start + change
    end
    time = time / duration * 2
    if time < 1 then
        return change / 2 * pow(2, 10 * (time - 1)) + start - change * 0.0005
    else
        time = time - 1
        return change / 2 * 1.0005 * (-pow(2, -10 * time) + 2) + start
    end
end

function EasingsLib.out_in_expo(time, start, change, duration)
    if time < duration / 2 then
        return EasingsLib.out_expo(time * 2, start, change / 2, duration)
    else
        return EasingsLib.in_expo((time * 2) - duration, start + change / 2, change / 2, duration)
    end
end

function EasingsLib.in_circ(time, start, change, duration)
    time = time / duration
    return (-change * (sqrt(1 - pow(time, 2)) - 1) + start)
end

function EasingsLib.out_circ(time, start, change, duration)
    time = time / duration - 1
    return (change * sqrt(1 - pow(time, 2)) + start)
end

function EasingsLib.in_out_circ(time, start, change, duration)
    time = time / duration * 2
    if time < 1 then
        return -change / 2 * (sqrt(1 - time * time) - 1) + start
    else
        time = time - 2
        return change / 2 * (sqrt(1 - time * time) + 1) + start
    end
end

function EasingsLib.out_in_circ(time, start, change, duration)
    if time < duration / 2 then
        return EasingsLib.out_circ(time * 2, start, change / 2, duration)
    else
        return EasingsLib.in_circ((time * 2) - duration, start + change / 2, change / 2, duration)
    end
end

function EasingsLib.in_elastic(time, start, change, duration, amplitude, period)
    if time == 0 then
        return start
    end

    time = time / duration

    if time == 1 then
        return start + change
    end

    if not period then
        period = duration * 0.3
    end

    local s

    if not amplitude or amplitude < abs(change) then
        amplitude = change
        s = period / 4
    else
        s = period / (2 * pi) * asin(change / amplitude)
    end

    time = time - 1

    return -(amplitude * pow(2, 10 * time) * sin((time * duration - s) * (2 * pi) / period)) + start
end

function EasingsLib.out_elastic(time, start, change, duration, amplitude, period)
    if time == 0 then
        return start
    end

    time = time / duration

    if time == 1 then
        return start + change
    end

    if not period then
        period = duration * 0.3
    end

    local s

    if not amplitude or amplitude < abs(change) then
        amplitude = change
        s = period / 4
    else
        s = period / (2 * pi) * asin(change / amplitude)
    end

    return amplitude * pow(2, -10 * time) * sin((time * duration - s) * (2 * pi) / period) + change + start
end

function EasingsLib.in_out_elastic(time, start, change, duration, amplitude, period)
    if time == 0 then
        return start
    end

    time = time / duration * 2

    if time == 2 then
        return start + change
    end

    if not period then
        period = duration * (0.3 * 1.5)
    end
    if not amplitude then
        amplitude = 0
    end

    local s

    if not amplitude or amplitude < abs(change) then
        amplitude = change
        s = period / 4
    else
        s = period / (2 * pi) * asin(change / amplitude)
    end

    if time < 1 then
        time = time - 1
        return -0.5 * (amplitude * pow(2, 10 * time) * sin((time * duration - s) * (2 * pi) / period)) + start
    else
        time = time - 1
        return amplitude * pow(2, -10 * time) * sin((time * duration - s) * (2 * pi) / period) * 0.5 + change + start
    end
end

function EasingsLib.out_in_elastic(time, start, change, duration, amplitude, period)
    if time < duration / 2 then
        return EasingsLib.out_elastic(time * 2, start, change / 2, duration, amplitude, period)
    else
        return EasingsLib.in_elastic((time * 2) - duration, start + change / 2, change / 2, duration, amplitude, period)
    end
end

function EasingsLib.in_back(time, start, change, duration, s)
    if not s then
        s = 1.70158
    end
    time = time / duration
    return change * time * time * ((s + 1) * time - s) + start
end

function EasingsLib.out_back(time, start, change, duration, s)
    if not s then
        s = 1.70158
    end
    time = time / duration - 1
    return change * (time * time * ((s + 1) * time + s) + 1) + start
end

function EasingsLib.in_out_back(time, start, change, duration, s)
    if not s then
        s = 1.70158
    end
    s = s * 1.525
    time = time / duration * 2
    if time < 1 then
        return change / 2 * (time * time * ((s + 1) * time - s)) + start
    else
        time = time - 2
        return change / 2 * (time * time * ((s + 1) * time + s) + 2) + start
    end
end

function EasingsLib.out_in_back(time, start, change, duration, s)
    if time < duration / 2 then
        return EasingsLib.out_back(time * 2, start, change / 2, duration, s)
    else
        return EasingsLib.in_back((time * 2) - duration, start + change / 2, change / 2, duration, s)
    end
end

function EasingsLib.out_bounce(time, start, change, duration)
    time = time / duration
    if time < 1 / 2.75 then
        return change * (7.5625 * time * time) + start
    elseif time < 2 / 2.75 then
        time = time - (1.5 / 2.75)
        return change * (7.5625 * time * time + 0.75) + start
    elseif time < 2.5 / 2.75 then
        time = time - (2.25 / 2.75)
        return change * (7.5625 * time * time + 0.9375) + start
    else
        time = time - (2.625 / 2.75)
        return change * (7.5625 * time * time + 0.984375) + start
    end
end

function EasingsLib.in_bounce(time, start, change, duration)
    return change - EasingsLib.out_bounce(duration - time, 0, change, duration) + start
end

function EasingsLib.in_out_bounce(time, start, change, duration)
    if time < duration / 2 then
        return EasingsLib.in_bounce(time * 2, 0, change, duration) * 0.5 + start
    else
        return EasingsLib.out_bounce(time * 2 - duration, 0, change, duration) * 0.5 + change * .5 + start
    end
end

function EasingsLib.out_in_bounce(time, start, change, duration)
    if time < duration / 2 then
        return EasingsLib.out_bounce(time * 2, start, change / 2, duration)
    else
        return EasingsLib.in_bounce((time * 2) - duration, start + change / 2, change / 2, duration)
    end
end

return EasingsLib
