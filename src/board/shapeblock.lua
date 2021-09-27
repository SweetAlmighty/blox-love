require "src/board/collidableblock"

ShapeBlock = CollidableBlock:extend()

function ShapeBlock:new(column, row)
    ShapeBlock.super.new(self, CollidableBlock.types.SHAPE, column, row)
    self._position = Vector(column * Block.width, row * Block.height)

    self._snap_blocks = { }
end

function ShapeBlock:get_snap_blocks()
    table.sort(self._collisions, 
        function (lhs, rhs)
            return distance(lhs._position, self._position) <
                    distance(rhs._position, self._position)
        end
    )
    return self._collisions
end

function ShapeBlock:set_pos(position)
    self._pos = position
end

function ShapeBlock:unsnap()
    for i=1, #self._collisions, 1 do
        self._collisions[i]:set_occupied(false)
    end
end

--[[
function ShapeBlock:draw()
    love.graphics.setColor(self._color.r, self._color.g, self._color.b)
    love.graphics.rectangle('fill', self._position.x, self._position.y, Block.width-1, Block.height-1)

    love.graphics.setColor(0, 0, 0)
    love.graphics.print(self._pos, self._position.x, self._position.y)
end
]]
