local Block = require "src/board/block"
local Object = require "src/lib/classic"
local GridBlock = require "src/board/gridblock"
local InternalGrid = require "src/board/internalgrid"

local Grid = Object:extend()

local random = love.math.random
local newTransform = love.math.newTransform
local newSpriteBatch = love.graphics.newSpriteBatch

function Grid:new(center)
    self._shapes = {}
    self._blocks = {}
    self._center = center
    Grid.rows = random(4, 8)
    Grid.columns = random(4, 8)
    self._transform = newTransform()
    self._sprite_batch = newSpriteBatch(Block.texture)
    self._internal_grid = InternalGrid(Grid.columns, Grid.rows)

    self:initialize()
end

function Grid:initialize()
    for i = 1, Grid.columns do
        local row = {}
        for j = 1, Grid.rows do row[#row + 1] = nil end
        self._blocks[#self._blocks + 1] = row
    end

    local block
    for i = 1, Grid.columns do
        for j = 1, Grid.rows do
            block = self._internal_grid:get_block(i, j)
            self._blocks[i][j] = not block:disabled() and GridBlock(block:column(), block:row()) or nil
        end
    end

    local y = (Grid.rows / 2) * Block.height
    local x = (Grid.columns / 2) * Block.width
    self._transform = self._transform:translate(self._center.x - x, self._center.y - y)

    for _, column in ipairs(self._blocks) do
        for _, row in pairs(column) do
            row:set_translation(self._transform:transformPoint(row:position():split()))
        end
    end

    Grid.blocks = self._blocks
end

function Grid:get_shapes() return self._internal_grid:get_shapes() end

function Grid:draw(sprite_batch)
    for _, column in ipairs(self._blocks) do
        for _, row in pairs(column) do
            sprite_batch:setColor(row:color():split())
            sprite_batch:add(row:translation():split())
        end
    end
end

function Grid:is_complete()
    for _, column in ipairs(self._blocks) do
        for _, row in pairs(column) do
            if not row:occupied() then return false end
        end
    end

    return true
end

return Grid
