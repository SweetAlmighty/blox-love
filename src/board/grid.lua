require "src/board/gridblock"
require "src/board/internalgrid"

local null = 'nil'

Grid = Object:extend()

function Grid:new(center)
    self._shapes = { }
    self._blocks = { }
    self._center = center
    self._rows = math.random(4, 8)
    self._columns = math.random(4, 8)
    self._internal_grid = InternalGrid(self._columns, self._rows)

    Grid.rows = self._rows
    Grid.columns = self._columns

    local y = (self._rows/2) * Block.height
    local x = (self._columns/2) * Block.width
    self._start = Vector(center.x - x, center.y - y)

    self:initialize()
end

function Grid:initialize()
    for i=1, self._columns, 1 do
        local row = { }
        for j=1, self._rows, 1 do
            row[#row+1] = nil
        end
        self._blocks[#self._blocks+1] = row
    end

    for i=1, self._columns, 1 do
        for j=1, self._rows, 1 do
            local block = self._internal_grid:get_block(i, j)
            if block._status ~= -1 then
                self._blocks[i][j] = GridBlock(block:column(), block:row(), self._start)
            else
                self._blocks[i][j] = null
            end
        end
    end

    Grid.blocks = self._blocks
end

function Grid:get_shapes()
    return self._internal_grid._shapes
end

function Grid:draw()
    for i=1, #self._blocks, 1 do
        for j=1, #self._blocks[i], 1 do
            if self._blocks[i][j] ~= null then
                self._blocks[i][j]:draw()
            end
        end
    end
end

function Grid:is_complete()
    for i=1, #self._blocks, 1 do
        for j=1, #self._blocks[i], 1 do
            if self._blocks[i][j] ~= null then
                if not self._blocks[i][j]:is_occupied() then
                    return false
                end
            end
        end
    end
    return true
end
