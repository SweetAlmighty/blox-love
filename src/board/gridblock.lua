local Color = require "src/misc/color"
local Block = require "src/board/block"
local Vector = require "src/lib/brinevector"
local CollidableBlock = require "src/board/collidableblock"

local GridBlock = CollidableBlock:extend()

local normal = Color(1, 1, 1)
local hover = Color(0.5, 0.5, 0.5)

function GridBlock:new(column, row)
    GridBlock.super.new(self, CollidableBlock.types.GRID, column, row)

    self._occupied = false
    self:position(Vector((column - 1) * Block.width, (row - 1) * Block.height))
end

function GridBlock:occupied(value)
    if value ~= nil then
        self._occupied = value
    else return self._occupied end
end

function GridBlock:set_color(snappable) GridBlock.super.color(self, snappable and hover or normal) end

return GridBlock
