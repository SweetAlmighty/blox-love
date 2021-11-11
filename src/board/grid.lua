require "src/board/gridblock"
require "src/board/internalgrid"

local null = 'nil'

Grid = Object:extend()

function Grid:new(center)
    self._shapes = {}
    self._blocks = {}
    self._center = center
    self._rows = math.random(4, 8)
    self._columns = math.random(4, 8)
    self._transform = love.math.newTransform()
    self._internal_grid = InternalGrid(self._columns, self._rows)
    self._sprite_batch = love.graphics.newSpriteBatch(Block.texture)

    Grid.rows = self._rows
    Grid.columns = self._columns

    self:initialize()
end

function Grid:initialize()
    for i = 1, self._columns do
        local row = {}
        for j = 1, self._rows do
            row[#row + 1] = nil
        end
        self._blocks[#self._blocks + 1] = row
    end

    for i = 1, self._columns do
        for j = 1, self._rows do
            local block = self._internal_grid:get_block(i, j)
            if block._status ~= -1 then
                self._blocks[i][j] = GridBlock(block:column(), block:row())
            else
                self._blocks[i][j] = null
            end
        end
    end

    local y = (self._rows / 2) * Block.height
    local x = (self._columns / 2) * Block.width
    self._transform = self._transform:translate(self._center.x - x, self._center.y - y)

    for _, column in ipairs(self._blocks) do
        for _, row in ipairs(column) do
            if row ~= null then
                row:set_translation(self._transform:transformPoint(row._position.x, row._position.y))
            end
        end
    end

    Grid.blocks = self._blocks
end

function Grid:get_shapes() return self._internal_grid._shapes end

function Grid:draw()
    self._sprite_batch:clear()

    local color = { }
    local translation = { }

    for _, column in ipairs(self._blocks) do
        for _, row in ipairs(column) do
            if row ~= null then
                color = row:get_color()
                translation = row:get_translation()

                self._sprite_batch:setColor(color.r, color.g, color.b)
                self._sprite_batch:add(translation.x, translation.y)
            end
        end
    end

    love.graphics.draw(self._sprite_batch)
end

function Grid:is_complete()
    for _, column in ipairs(self._blocks) do
        for _, row in ipairs(column) do
            if row ~= null then
                if not row:is_occupied() then
                    return false
                end
            end
        end
    end

    return true
end
