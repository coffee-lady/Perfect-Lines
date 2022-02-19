local App = require('src.app')

local SoundsMSG = App.constants.msg.sounds
local DataStorageConfig = App.config.data_storage
local FILE = DataStorageConfig.file
local KEY_SOUNDS_DISABLED = DataStorageConfig.keys.is_sound_disabled

local DEBUG = App.config.debug_mode.SoundService
local GATE_TIME = 0.3

local Async = App.libs.async
local Event = App.libs.Event
local Debug = App.libs.debug

--- @class SoundService
local SoundService = class('SoundService')

SoundService.__cparams = {'data_storage_use_cases'}

function SoundService:initialize(data_storage_use_cases)
    self.data_storage_use_cases = data_storage_use_cases
    self.sounds_disabled = self.data_storage_use_cases:get(FILE, KEY_SOUNDS_DISABLED)

    self.debug = Debug('[SoundService]', DEBUG)

    self.gated_sounds = {}

    self.event_play_sound = Event()
    self.event_pause_sound = Event()
    self.event_stop_sound = Event()

    self.event_play_sound:add(self.on_play_sound, self)
    self.event_pause_sound:add(self.on_pause_sound, self)
    self.event_stop_sound:add(self.on_stop_sound, self)
end

function SoundService:on_play_sound(url, play_properties, callback)
    self.debug:log('play', url, self.debug:inspect(play_properties))
    sound.play(url, play_properties, callback)
end

function SoundService:on_pause_sound(url, is_paused)
    self.debug:log('pause', url, is_paused)
    sound.pause(url, is_paused)
end

function SoundService:on_stop_sound(url)
    self.debug:log('stop', url)
    sound.stop(url)
end

function SoundService:toggle_sounds()
    if self.sounds_disabled then
        self:enable_sounds()
    else
        self:disable_sounds()
    end
end

function SoundService:enable_sounds()
    self.sounds_disabled = false
    self.data_storage_use_cases:set(FILE, KEY_SOUNDS_DISABLED, self.sounds_disabled)
end

function SoundService:disable_sounds()
    self.sounds_disabled = true
    self.data_storage_use_cases:set(FILE, KEY_SOUNDS_DISABLED, self.sounds_disabled)
end

function SoundService:is_sound_enabled()
    return not self.sounds_disabled
end

function SoundService:play(url, play_properties, callback)
    if self.sounds_disabled then
        return
    end

    self.event_play_sound:emit(url, play_properties, callback)
end

function SoundService:play_force(url, play_properties, callback)
    self.event_play_sound:emit(url, play_properties, callback)
end

function SoundService:play_async(url, play_properties)
    if self.sounds_disabled then
        return
    end

    local tmp_play_sound = hash('_tmp_play_sound')

    Async(
        function(done)
            self.event_play_sound:emit(url, play_properties, done)
        end
    )
end

function SoundService:pause(url)
    if self.sounds_disabled then
        return
    end

    self.event_pause_sound:emit(url, true)
end

function SoundService:resume(url)
    if self.sounds_disabled then
        return
    end

    self.event_pause_sound:emit(url, false)
end

function SoundService:stop(url)
    if self.sounds_disabled then
        return
    end

    self.event_stop_sound:emit(url)
end

function SoundService:update(dt)
    for key, _ in pairs(self.gated_sounds) do
        self.gated_sounds[key] = self.gated_sounds[key] - dt
        if self.gated_sounds[key] < 0 then
            self.gated_sounds[key] = nil
        end
    end
end

function SoundService:play_gated_sound(url, play_properties)
    if self.gated_sounds[url] then
        return
    end

    self.gated_sounds[url] = GATE_TIME
    self.event_play_sound:emit(url, play_properties)
end

return SoundService
