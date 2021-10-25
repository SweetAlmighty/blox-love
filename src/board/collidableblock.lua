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
    self._color = Color(1, 1, 1)
    self._position = Vector()--column * Block.width, row * Block.height)

    CollidableBlock.blocks[#CollidableBlock.blocks + 1] = self
end

function CollidableBlock:get_collisions()
    return self._collisions
end

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

function CollidableBlock:get_position()
    return self._position
end

function CollidableBlock:set_position(x, y)
    self._position.x = x
    self._position.y = y
end

function CollidableBlock:move(dx, dy)
    self._position.x = self._position.x + dx
    self._position.y = self._position.y + dy
end

function CollidableBlock:set_color(color)
    self._color = color
end

function CollidableBlock:draw()
    --[[
    love.graphics.setColor(1, 0, 0)
    for i=1, #self._collisions do
        love.graphics.line(self._position.x, self._position.y, self._collisions[i]._position.x, self._collisions[i]._position.y)
    end
    ]]

    love.graphics.setColor(self._color.r, self._color.g, self._color.b)
    love.graphics.draw(Block.texture, self._position.x, self._position.y)--, Block.width-1, Block.height-1)
    --love.graphics.rectangle('fill', self._position.x, self._position.y, Block.width-1, Block.height-1)

    --[[
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(self:column() .. "" .. self:row(), self._position.x, self._position.y)
    ]]

end
