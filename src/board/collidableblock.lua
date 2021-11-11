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

    self._scale = 1
    self._type = type
    self._collisions = {}
    self._position = Vector()
    self._color = Color(1, 1, 1)
    self._translated_position = Vector()
    self._size = Vector(Block.width/self._scale, Block.height/self._scale)
    self._offset =  self._size / 2

    CollidableBlock.blocks[#CollidableBlock.blocks + 1] = self
end

function CollidableBlock:get_color() return self._color end

function CollidableBlock:set_color(color) self._color = color end

function CollidableBlock:get_position() return self._position end

function CollidableBlock:get_collisions() return self._collisions end

function CollidableBlock:get_translation() return self._translated_position end

function CollidableBlock:get_center() return self._translated_position + self._offset end

function CollidableBlock:collision_enter(other)
    local index = find_index(self._collisions, other)
    if index == nil then
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

function CollidableBlock:set_scale(scale)
    self._scale = scale
    self._size = Vector(Block.width/self._scale, Block.height/self._scale)
    self._offset =  self._size / 2
end

function CollidableBlock:set_translation(x, y)
    self._translated_position.x = x
    self._translated_position.y = y
end

function CollidableBlock:check_bounds(x, y)
    local pos = self._translated_position
    if x >= pos.x and x < pos.x + self._size.x then
        if y >= pos.y and y < pos.y + self._size.y then
            return true
        end
    end
end