local Utils = require "src/utils/util"
local Object = require "src/lib/classic"
local Coordinate = require "src/utils/coordinate"
local InternalBlock = require "src/board/internalblock"

local InternalGrid = Object:extend()

local function find_next(self, blocks)
    local neighbors = {}
    local next_block = nil

    for i = #blocks, 1, -1 do
        neighbors = Utils.shuffle(blocks[i]:get_neighbors())
        for j = 1, #neighbors do
            next_block = self._blocks[neighbors[j].column][neighbors[j].row]
            if next_block:available() then
                Utils.wipe(neighbors)
                return next_block
            end
        end
    end

    return nil
end

function InternalGrid:new(columns, rows)
    self._rows = rows
    self._blocks = {}
    self._shapes = {}
    self._gap_count = 0
    self._columns = columns

    for i = 1, columns do
        local row = {}
        for j = 1, rows do
            row[#row + 1] = InternalBlock(i, j)
            row[#row]:init_neighbors(columns, rows)
        end
        self._blocks[#self._blocks + 1] = row
    end

    self:create_gaps()
    self:create_shapes()
end

function InternalGrid:get_shapes() return self._shapes end

function InternalGrid:get_block(column, row) return self._blocks[column][row] end

function InternalGrid:create_gaps()
    -- Determine whether this grid will contain gaps
    if love.math.random() > 0.5 then
        local that = love.math.random(1, #self._blocks / 2)
        local row = that % self._rows
        local column = math.ceil(that / self._columns)

        local gap = {self._blocks[column][row]}
        local points = {Coordinate(column, row)}

        while #gap < self._rows do
            local block = find_next(self, gap)
            if block ~= nil then
                gap[#gap + 1] = block
                points[#points + 1] = Coordinate(block:column(), block:row())
            end
        end

        -- Create symmetrical gaps
        if love.math.random() > 0.5 then
            for _, block in ipairs(gap) do
                -- Adding 1 to Rows and Columns since lua indices start at 1
                points[#points + 1] = Coordinate((self._columns + 1) - block:column(), (self._rows + 1) - block:row())
            end
        end

        Utils.for_each(points, function(i, v)
            self._gap_count = self._gap_count + 1
            self._blocks[v.column][v.row]:disable()
        end)

        Utils.wipe(gap)
        Utils.wipe(points)
    end
end

function InternalGrid:create_shapes()
    local amount = 0
    self._shapes = {}

    local grid_points = {}
    for i = 1, self._columns do
        for j = 1, self._rows do
            grid_points[#grid_points + 1] = Coordinate(i, j)
        end
    end
    grid_points = Utils.shuffle(grid_points)

    local shapes = {}
    while amount < #grid_points - self._gap_count do
        Utils.for_each(grid_points, function(i, v)
            local shape = {}
            local block = self._blocks[v.column][v.row]
            if block:available() then
                for j = 1, 5 do
                    if block ~= nil and block:available() then
                        block:set_status(#shapes + 1)
                        shape[#shape + 1] = block
                        block = find_next(self, shape)
                    end
                end

                self._shapes[#self._shapes + 1] = shape
                amount = amount + #shape
            end
        end)
    end
    Utils.wipe(grid_points)
end

return InternalGrid
