local Object = require "src/lib/classic"

local Sound = Object:extend()

local play = love.audio.play
local newSource = love.audio.newSource

function Sound:new(filename, type)
    self._type = type
    self._data = love.sound.newSoundData(filename)
    self._source = newSource(self._data, self._type)
end

function Sound:set_volume()
    local volume = 0
    if self._type == "static" then
        volume = Sound.sfxMute and 0 or Sound.sfxVolume
    else
        volume = Sound.musicMute and 0 or Sound.musicVolume
    end

    if self._source ~= nil then
        self._source:setVolume(volume)
    end
end

function Sound:play()
    self._source:stop()
    play(self._source)
end

function Sound:play_looping()
    self._source:stop()
    self._source:setLooping(true)
    play(self._source)
end

function Sound:stop()
    if self._source ~= nil then
        self._source:stop()
        self._source = nil
    end
end

return Sound
