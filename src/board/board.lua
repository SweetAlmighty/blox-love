local Grid = require "src/board/grid"
local Utils = require "src/utils/utils"
local Shape = require "src/board/shape"
local Object = require "src/lib/classic"
local Layout = require "src/board/layout"
local Vector = require "src/lib/brinevector"
local Resources = require "src/utils/resources"
local ShapeBlock = require "src/board/shapeblock"
local Collisions = require "src/utils/collisions"
local CollidableBlock = require "src/board/collidableblock"

local Board = Object:extend()

local function select_shape(self, shape)
    self._shape_interaction:play()
    self._selected_shape = shape
    if self._selected_shape:snapped() then
        self._selected_shape:unsnap()
    else
        self._selected_shape:maximize()
    end
end

local function deselect_shape(self)
    self._shape_interaction:play()

    if self._selected_shape:attempt_snap() then
        self._selected_shape:snap()
    else
        self._selected_shape:minimize()
        local index = Utils.find_index(self._shapes, self._selected_shape)
        self._selected_shape:move((self._rects[index] - self._shapes[index]:center()):split())
    end

    self._selected_shape = nil
end

function Board:new(on_grid_complete)
    self._rects = {}
    self._shapes = {}
    self._layout = Layout()
    self._on_grid_complete = on_grid_complete
    self._shape_interaction = Resources.load_sfx("Switch sounds 1")

    self:create_grid_and_shapes()
end

function Board:resize() self._layout:resize() end

function Board:create_grid_and_shapes()
    self._grid = Grid(self._layout:get_grid_center())
    self:create_shapes()
    self:segment_sideboard()
    self:place_shapes()
end

function Board:create_shapes()
    local shapes = self._grid:get_shapes()

    local shape = {}
    local coord = nil
    for i, v in ipairs(shapes) do
        shape = {}
        for j, z in ipairs(v) do
            coord = z:coords()
            shape[#shape + 1] = ShapeBlock(coord.column, coord.row)
        end
        self._shapes[#self._shapes + 1] = Shape(shape)
    end

    self._shapes = Utils.shuffle(self._shapes)
end

function Board:reset()
    self:unsnap_shapes()
    self:place_shapes()
    self._selected_shape = nil
end

function Board:regen()
    Utils.wipe(self._shapes)
    Utils.wipe(CollidableBlock.blocks)
    self._selected_shape = nil
    self:create_grid_and_shapes()
end

function Board:update(dt)
    Collisions.check_collisions(CollidableBlock.blocks)
    if self._grid:is_complete() then
        if self._on_grid_complete then
            self._on_grid_complete()
        end
    end
end

function Board:draw()
    self._layout:draw()
    self._grid:draw()

    for i = #self._shapes, 1, -1 do
        if self._shapes[i] ~= self._selected_shape then
            self._shapes[i]:draw()
        end
    end

    if self._selected_shape ~= nil then
        self._selected_shape:draw()
    end
end

function Board:mouse_moved(dx, dy)
    if self._selected_shape then
        self._selected_shape:move(dx, dy)
    end
end

function Board:mouse_pressed(x, y)
    for _, shape in ipairs(self._shapes) do
        if shape:selected(x, y) then
            select_shape(self, shape)
            break
        end
    end
end

function Board:mouse_released(x, y)
    if self._selected_shape then
        deselect_shape(self)
    end
end

function Board:unsnap_shapes()
    for _, shape in ipairs(self._shapes) do
        if shape:snapped() then
            shape:move_to_sideboard()
        end
    end
end

function Board:segment_sideboard()
    local x, y, w, h = self._layout:get_side_rect()

    local columns = 2
    local width = w / columns
    local rows = math.ceil(#self._shapes / 2)
    local height = math.ceil(h / rows)

    local rect = {}
    self._rects = {}
    local size = Vector(width, height)

    local _x, _y
    for i = 1, columns do
        for j = 1, rows do
            _x = x + (width * (i - 1))
            _y = y + (height * (j - 1))
            self._rects[#self._rects + 1] = Vector(_x, _y) + (size / 2)
        end
    end
end

function Board:place_shapes()
    for i, shape in ipairs(self._shapes) do
        shape:move((self._rects[i] - shape:center()):split())
    end
end

return Board
