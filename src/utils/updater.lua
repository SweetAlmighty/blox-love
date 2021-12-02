local Utils = require "src/utils/utils"
local Object = require "src/lib/classic"

local Updater = Object:extend()

function Updater:new(updates_per_sec, func)
	self._func = func
	self._now = Utils.now
	self._next_update = self:_now()
	self._current_time = self:_now()
	self._skip_ticks = 1000/updates_per_sec
end

function Updater:update()
    self._current_time = self._now()
    if self._next_update < self._current_time then
    	self._func()
        self._next_update = self._next_update + self._skip_ticks
    end
end

return Updater
