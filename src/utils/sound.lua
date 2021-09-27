Sound = Object:extend()

local newSource = love.audio.newSource

function Sound:new(filename, type)
    self._type = type
    self._source = nil
    self._data = love.sound.newSoundData(filename)
end

function Sound:play()
    self._source = newSource(self._data, self._type)
    self._source:play()
end

function Sound:play_looping()
    self._source = newSource(self._data, self._type)
    self._source:setLooping(true)
    self._source:play()
end

function Sound:stop()
    if self._source ~= nil then
        self._source:stop()
        self._source = nil
    end
end
