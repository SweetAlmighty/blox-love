require "src/board/collidableblock"

ShapeBlock = CollidableBlock:extend()

function ShapeBlock:new(column, row)
    ShapeBlock.super.new(self, CollidableBlock.types.SHAPE, column, row)
    
    self._snap_blocks = {}
    self._unsnap = function(i, v) v:occupied(false) end
    self._distance_sort = function (lhs, rhs)
        return distance(lhs:position(), self:position()) <
                distance(rhs:position(), self:position())
    end
end

function ShapeBlock:get_snap_blocks()
    table.sort(self:collisions(), self._distance_sort)
    return self:collisions()
end

function ShapeBlock:maximize() self:scale(1) end

function ShapeBlock:minimize() self:scale(0.5) end

function ShapeBlock:unsnap() foreach(self:collisions(), self._unsnap) end
