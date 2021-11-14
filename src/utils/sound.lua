Sound = Object:extend()

local newSource = love.audio.newSource

function Sound:new(filename, type)
    self._type = type
    self._source = nil
    self._data = love.sound.newSoundData(filename)
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
    self._source = newSource(self._data, self._type)
    self:set_volume()
    self._source:play()
end

function Sound:play_looping()
    self._source = newSource(self._data, self._type)
    self:set_volume()
    self._source:setLooping(true)
    self._source:play()
end

function Sound:stop()
    if self._source ~= nil then
        self._source:stop()
        self._source = nil
    end
end
