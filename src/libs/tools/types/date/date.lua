local HOURS_IN_DAY = 24
local MIN_IN_HOUR = 60
local SEC_IN_MIN = 60
local MSEC_IN_SEC = 1000

local floor = math.floor
local fmod = math.fmod
local format = string.format

local DateLib = {}

function DateLib._get_metrics(sec)
    local days = floor(sec / 86400)
    local hours = floor(fmod(sec, 86400) / 3600)
    local minutes = floor(fmod(sec, 3600) / 60)
    local seconds = floor(fmod(sec, 60))
    return days, hours, minutes, seconds
end

function DateLib.msec_to_sec(msec)
    return msec / MSEC_IN_SEC
end

function DateLib.sec_to_min(seconds)
    return seconds / SEC_IN_MIN
end

function DateLib.hours_to_sec(hours)
    return hours * MIN_IN_HOUR * SEC_IN_MIN
end

function DateLib.format_ms(minutes, seconds)
    local seconds_elapsed = minutes * SEC_IN_MIN + seconds

    return os.date('%M:%S', seconds_elapsed)
end

function DateLib.format_hm(hours, minutes)
    local seconds_elapsed = hours * MIN_IN_HOUR * SEC_IN_MIN + minutes * SEC_IN_MIN

    return os.date('%H:%M', seconds_elapsed)
end

function DateLib.format_hms(hours, minutes, seconds)
    local seconds_elapsed = hours * MIN_IN_HOUR * SEC_IN_MIN + minutes * SEC_IN_MIN + seconds

    return os.date('%H:%M:%S', seconds_elapsed)
end

function DateLib.format_hm_from_s(sec)
    local days, hours, minutes, seconds = DateLib._get_metrics(sec)
    return format('%02d:%02d', hours, minutes)
end

function DateLib.format_ms_from_s(sec)
    local days, hours, minutes, seconds = DateLib._get_metrics(sec)
    return format('%02d:%02d', minutes, seconds)
end

function DateLib.format_from_s(sec)
    if sec >= SEC_IN_MIN * MIN_IN_HOUR then
        return DateLib.format_hms_from_s(sec)
    end

    return DateLib.format_ms_from_s(sec)
end

function DateLib.format_hms_from_s(sec)
    local days, hours, minutes, seconds = DateLib._get_metrics(sec)
    return format('%02d:%02d:%02d', hours, minutes, seconds)
end

function DateLib.get_days(seconds)
    return seconds / HOURS_IN_DAY / MIN_IN_HOUR / SEC_IN_MIN
end

function DateLib.is_year_leap(year)
    return (year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0
end

function DateLib.get_table_ms_from_s(seconds)
    return {
        minutes = math.floor(seconds / SEC_IN_MIN),
        seconds = seconds % SEC_IN_MIN,
    }
end

function DateLib.get_s_from_table_ms(table)
    return table.minutes * SEC_IN_MIN + table.seconds
end

return DateLib
