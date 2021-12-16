local Block = require "src/board/block"
local Coordinate = require "src/misc/coordinate"

local InternalBlock = Block:extend()

function InternalBlock:new(column, row)
    InternalBlock.super.new(self, column, row)
    self._status = 0
    self._neighbors = {}
end

function InternalBlock:init_neighbors(columns, rows)
    if self:column() - 1 >= 1 then
        self._neighbors[#self._neighbors + 1] = Coordinate(self:column() - 1, self:row())
    end

    if self:row() - 1 >= 1 then
        self._neighbors[#self._neighbors + 1] = Coordinate(self:column(), self:row() - 1)
    end

    if self:column() + 1 <= columns then
        self._neighbors[#self._neighbors + 1] = Coordinate(self:column() + 1, self:row())
    end

    if self:row() + 1 <= rows then
        self._neighbors[#self._neighbors + 1] = Coordinate(self:column(), self:row() + 1)
    end
end

function InternalBlock:disable() self._status = -1 end
function InternalBlock:available() return self._status == 0 end
function InternalBlock:disabled() return self._status == -1 end
function InternalBlock:set_status(value) self._status = value end
function InternalBlock:get_neighbors() return self._neighbors end

return InternalBlock
