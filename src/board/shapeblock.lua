require "src/board/collidableblock"

ShapeBlock = CollidableBlock:extend()

function ShapeBlock:new(column, row)
    ShapeBlock.super.new(self, CollidableBlock.types.SHAPE, column, row)
    self._position = Vector()

    self._snap_blocks = {}
    self._unsnap = function(i, v) v:set_occupied(false) end
    self._distance_sort = function (lhs, rhs)
        return distance(lhs._position, self._position) <
                distance(rhs._position, self._position)
    end
end

function ShapeBlock:get_snap_blocks()
    table.sort(self._collisions, self._distance_sort)
    return self._collisions
end

function ShapeBlock:unsnap()
    foreach(self._collisions, self._unsnap)
end
