local Grid = require "src/board/grid"
local Utils = require "src/utils/util"
local Color = require "src/utils/color"
local Block = require "src/board/block"
local Object = require "src/lib/classic"
local Vector = require "src/lib/brinevector"

local Shape = Object:extend()

local color_index = 1

local lg = love.graphics

local function get_block(pos)
    if pos.row > 0 and pos.row <= Grid.rows then
        if pos.column > 0 and pos.column <= Grid.columns then
            return Grid.blocks[pos.column][pos.row]
        end
    end
end

local function set_grid_block_colors(self, snappable)
    Utils.for_each(self._snap_points, function(i, v) v:set_color(snappable) end)
end

local function set_grid_blocks_occupied_state(self)
    Utils.for_each(self._snap_points, function(i, v) v:occupied(self._snapped) end)
end

local function has_unoccupied_collisions(self, cols)
    local valid = 0
    if #cols > 0 then
        for i, v in ipairs(cols) do
            if not v:occupied() then valid = valid + 1 end
        end
    end
    return valid ~= 0
end

local function has_valid_collisions(self)
    local collisions = {}
    Utils.for_each(self._blocks, function(i,v)
        if has_unoccupied_collisions(self, v:collisions()) then
            collisions[#collisions + 1] = true
        end
    end)
    return #collisions == #self._blocks
end

local function determine_snap_points(self)
    set_grid_block_colors(self, false)

    self._snap_points = {}

    if has_valid_collisions(self) then
        for _, snap_block in ipairs(self._blocks[1]:get_snap_blocks()) do
            for _, block in ipairs(self._blocks) do
                local next = get_block(snap_block:coords() + (block:coords() - self._blocks[1]:coords()))

                if next == nil or next:occupied() then
                    self._snap_points = {}
                    break
                end

                self._snap_points[#self._snap_points + 1] = next
            end

            if #self._snap_points ~= 0 then break end
        end
    end

    set_grid_block_colors(self, true)
end

local function difference(self)
    return (self._snap_points[1]:translation() - self._blocks[1]:translation()):split()
end

function Shape:new(blocks)
    self._snapped = false
    self._blocks = blocks
    self._snap_points = {}
    self._color = Color.colors[color_index]
    self._transform = love.math.newTransform()
    self._sprite_batch = lg.newSpriteBatch(Block.texture)
    color_index = color_index == #Color.colors and 1 or color_index + 1

    self:minimize()

    Utils.for_each(self._blocks, function(i,v)
        local coords = v:coords() - blocks[1]:coords()
        v:position(Vector(coords.column * Block.width, coords.row * Block.height))
    end)

    self:move(0, 0)

    Utils.for_each(self._blocks, function(i,v) v:color(self._color) end)
end

function Shape:snapped() return self._snapped end

function Shape:block_count() return #self._blocks end

function Shape:get_block(index) return self._blocks[index] end

function Shape:attempt_snap() return has_valid_collisions(self) end

function Shape:draw()
    self._sprite_batch:clear()

    self._sprite_batch:setColor(self._color.r, self._color.g, self._color.b)
    Utils.for_each(self._blocks, function(i, v)
        local pos = v:translation()
        self._sprite_batch:add(pos.x, pos.y, 0, self._scale, self._scale)
    end)

    lg.draw(self._sprite_batch)
end

function Shape:move(dx, dy)
    self._transform = self._transform:translate(dx/self._scale, dy/self._scale)

    Utils.for_each(self._blocks, function(i, v)
        v:set_translation(self._transform:transformPoint(v:position():split()))
    end)

    determine_snap_points(self)
end

function Shape:snap()
    self._snapped = #self._snap_points == #self._blocks

    if self._snapped then
        self:move(difference(self))
        Utils.for_each(self._snap_points, function(i, v) v:occupied(true) end)
    end

    set_grid_blocks_occupied_state(self)
end

function Shape:unsnap()
    if self._snapped then
        self._snapped = false
        Utils.for_each(self._blocks, function(i,v) v:unsnap() end)
    end
end

function Shape:move_to_sideboard()
    self._snapped = false
    Utils.for_each(self._blocks, function(i,v)
        v:unsnap()
        v:reset_collisions()
    end)
    set_grid_blocks_occupied_state(self)
    self:minimize()
end

function Shape:maximize()
    self._scale = 1
    self._transform = self._transform:scale(self._scale*2)
    self:move(0, 0)

    Utils.for_each(self._blocks, function(i,v) v:maximize() end)
end

function Shape:minimize()
    self._scale = 0.5
    self._transform = self._transform:scale(self._scale)
    self:move(0, 0)

    Utils.for_each(self._blocks, function(i,v) v:minimize() end)
end

function Shape:selected(x, y)
    for _, block in ipairs(self._blocks) do
        if block:check_bounds(x, y) then
            self._selected = true
            return true
        end
    end

    self._selected = false
    return false
end

function Shape:center()
    local pos = Vector()
    Utils.for_each(self._blocks, function(i, v) pos = pos + v:center() end)
    return pos / #self._blocks
end

return Shape
