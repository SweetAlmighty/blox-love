require "src/board/collidableblock"

GridBlock = CollidableBlock:extend()

local normal = Color(1, 1, 1)
local hover = Color(0.5, 0.5, 0.5)

function GridBlock:new(column, row)
    GridBlock.super.new(self, CollidableBlock.types.GRID, column, row)

    self._occupied = false
    self._position = Vector((column - 1) * Block.width, (row - 1) * Block.height)
end

function GridBlock:set_base_color(snappable)
    GridBlock.super.set_color(self, snappable and hover or normal)
end

function GridBlock:is_occupied() return self._occupied end

function GridBlock:set_occupied(occupied) self._occupied = occupied end
