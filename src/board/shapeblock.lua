require "src/board/collidableblock"

ShapeBlock = CollidableBlock:extend()

function ShapeBlock:new(column, row)
    ShapeBlock.super.new(self, CollidableBlock.types.SHAPE, column, row)
    self._position = Vector(column * Block.width, row * Block.height)

    self._snap_blocks = {}
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
    for i = 1, #self._collisions do
        self._collisions[i]:set_occupied(false)
    end
end
