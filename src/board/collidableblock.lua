require "src/board/block"

Vector = require "src/lib/brinevector"

CollidableBlock = Block:extend()

CollidableBlock.types = {
    GRID = 1,
    SHAPE = 2
}

CollidableBlock.blocks = {}

function CollidableBlock:new(type, column, row)
    CollidableBlock.super.new(self, column, row)

    self._type = type
    self._collisions = {}
    self._position = Vector()
    self._color = Color(1, 1, 1)
    self._translated_position = Vector()
    
    self:scale(type == CollidableBlock.types.SHAPE and 0.5 or 1)

    CollidableBlock.blocks[#CollidableBlock.blocks + 1] = self
end

function CollidableBlock:type() return self._type end

function CollidableBlock:collisions() return self._collisions end

function CollidableBlock:translation() return self._translated_position end

function CollidableBlock:center() return self:translation() + self._offset end

function CollidableBlock:color(value) if value then self._color = value else return self._color end end

function CollidableBlock:position(value) if value ~= nil then self._position = value else return self._position end end

function CollidableBlock:collision_enter(other)
    if find_index(self._collisions, other) == nil then
        table.insert(self._collisions, other)
        return true
    end
end

function CollidableBlock:collision_exit(other)
    local index = find_index(self._collisions, other)
    if index then
        table.remove(self._collisions, index)
        return true
    end
end

function CollidableBlock:scale(value)
    if value ~= nil then
        self._scale = value
        self._size = Vector(Block.width*self._scale, Block.height*self._scale)
        self._offset =  self._size / 2
    else
        return self._scale
    end
end

function CollidableBlock:set_translation(x, y)
    self._translated_position.x = x
    self._translated_position.y = y
end

function CollidableBlock:check_bounds(x, y)
    local pos = self:translation()
    if x >= pos.x and x < pos.x + self._size.x then
        if y >= pos.y and y < pos.y + self._size.y then
            return true
        end
    end
end