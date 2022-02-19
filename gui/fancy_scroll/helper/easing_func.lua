local pow = math.pow
local sin = math.sin
local cos = math.cos
local pi = math.pi
local sqrt = math.sqrt
local abs = math.abs

local function linear(t)
    return t
end

local function inBack(t)
    return t * t * t - t * sin(t * pi)
end

local function outBack(t)
    return 1 - inBack(1 - t)
end

local function inOutBack(t)
    return t < 0.5 and 0.5 * inBack(2 * t) or 0.5 * outBack(2 * t - 1) + 0.5
end

local function outBounce(t)
    return t < 4 / 11.0 and (121 * t * t) / 16.0 or t < 8 / 11.0 and (363 / 40.0 * t * t) - (99 / 10.0 * t) + 17 / 5.0 or t < 9 / 10.0 and
               (4356 / 361.0 * t * t) - (35442 / 1805.0 * t) + 16061 / 1805.0 or (54 / 5.0 * t * t) - (513 / 25.0 * t) + 268 / 25.0;
end

local function inBounce(t)
    return 1 - outBounce(1 - t)
end

local function inOutBounce(t)
    return t < 0.5 and 0.5 * inBounce(2 * t) or 0.5 * outBounce(2 * t - 1) + 0.5
end

local function inCirc(t)
    return 1 - sqrt(1 - (t * t));
end

local function outCirc(t)
    return sqrt((2 - t) * t)
end

local function inOutCirc(t)
    return t < 0.5 and 0.5 * (1 - sqrt(1 - 4 * (t * t))) or 0.5 * (sqrt(-((2 * t) - 3) * ((2 * t) - 1)) + 1);
end

local function inCubic(t)
    return t * t * t
end

local function outCubic(t)
    return inCubic(t - 1) + 1;
end

local function inOutCubic(t)
    return t < 0.5 and 4 * t * t * t or 0.5 * inCubic(2 * t - 2) + 1;
end

local function inElastic(t)
    return sin(13 * (pi * 0.5) * t) * pow(2, 10 * (t - 1))
end

local function outElastic(t)
    return sin(-13 * (pi * 0.5) * (t + 1)) * pow(2, -10 * t) + 1;
end

local function inOutElastic(t)
    return t < 0.5 and 0.5 * sin(13 * (pi * 0.5) * (2 * t)) * pow(2, 10 * ((2 * t) - 1)) or 0.5 *
               (sin(-13 * (pi * 0.5) * ((2 * t - 1) + 1)) * pow(2, -10 * (2 * t - 1)) + 2)
end

local function inExpo(t)
    if abs(t) < 0.001 then
        return t
    else
        return pow(2, 10 * (t - 1))
    end
end

local function outExpo(t)
    if abs(1 - t) < 0.001 then
        return t
    else
        return 1 - pow(2, -10 * t)
    end
end

local function inOutExpo(v)
    if abs(v) < 0.001 or abs(v - 1) < 0.001 then
        return v
    else
        return v < 0.5 and 0.5 * pow(2, (20 * v) - 10) or -0.5 * pow(2, (-20 * v) + 10) + 1
    end
end

local function inQuad(t)
    return t * t
end

local function outQuad(t)
    return -t * (t - 2)
end

local function inOutQuad(t)
    return t < 0.5 and 2 * t * t or -2 * t * t + 4 * t - 1;
end

local function inQuart(t)
    return t * t * t * t
end

local function outQuart(t)
    local u = t - 1
    return u * u * u * (1 - t) + 1
end

local function inOutQuart(t)
    return t < 0.5 and 8 * inQuart(t) or -8 * inQuart(t - 1) + 1
end

local function inQuint(t)
    return t * t * t * t * t
end

local function outQuint(t)
    return inQuint(t - 1) + 1
end

local function inOutQuint(t)
    return t < 0.5 and 16 * inQuint(t) or 0.5 * inQuint(2 * t - 2) + 1
end

local function inSine(t)
    return sin((t - 1) * (pi * 0.5)) + 1
end

local function outSine(t)
    return sin(t * (pi * 0.5))
end

local function inOutSine(t)
    return 0.5 * (1 - cos(t * pi))
end

return {
    linear = linear,
    inQuad = inQuad,
    outQuad = outQuad,
    inOutQuad = inOutQuad,
    inCubic = inCubic,
    outCubic = outCubic,
    inOutCubic = inOutCubic,
    inQuart = inQuart,
    outQuart = outQuart,
    inOutQuart = inOutQuart,
    inQuint = inQuint,
    outQuint = outQuint,
    inOutQuint = inOutQuint,
    inSine = inSine,
    outSine = outSine,
    inOutSine = inOutSine,
    inExpo = inExpo,
    outExpo = outExpo,
    inOutExpo = inOutExpo,
    inCirc = inCirc,
    outCirc = outCirc,
    inOutCirc = inOutCirc,
    inElastic = inElastic,
    outElastic = outElastic,
    inOutElastic = inOutElastic,
    inBack = inBack,
    outBack = outBack,
    inOutBack = inOutBack,
    inBounce = inBounce,
    outBounce = outBounce,
    inOutBounce = inOutBounce,
}

