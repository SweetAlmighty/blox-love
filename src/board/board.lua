require "src/board/shapeblock"
require "src/board/grid"
require "src/board/shape"
require "src/utils/collisions"
require "src/board/layout"

Board = Object:extend()

local function select_shape(self, shape)
    self._shape_interaction:play()
    self._selected_shape = shape
    self._selected_shape:unsnap()
end

local function deselect_shape(self)
    self._shape_interaction:play()

    if self._selected_shape:attempt_snap() then
        self._selected_shape:snap()
    else
        self._selected_shape:minimize()
        local index = find_index(self._shapes, self._selected_shape)
        self._selected_shape:move((self._rects[index] - self._shapes[index]:center()):split())
    end

    self._selected_shape = nil
end

function Board:new(onGridComplete)
    self._rects = {}
    self._shapes = {}
    self._layout = Layout()
    self._onGridComplete = onGridComplete
    self._grid = Grid(self._layout:get_grid_center())
    self._shape_interaction = Resources.LoadSFX("Switch sounds 1")

    self:create_shapes()
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

    self._shapes = shuffle(self._shapes)
end

function Board:reset()
    wipe(self._shapes)
    wipe(CollidableBlock.blocks)

    self._grid = Grid(self._layout:get_grid_center())

    self:create_shapes()
    self:place_shapes()
    self._selected_shape = nil
end

function Board:update(dt)
    check_collisions(CollidableBlock.blocks)
    if self._grid:is_complete() then
        if self._onGridComplete then
            self._onGridComplete()
        else
            self:reset()
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
            return
        end
    end
end

function Board:mouse_released(x, y)
    if self._selected_shape then
        deselect_shape(self)
    end
end

function Board:place_shapes()
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

    for i, shape in ipairs(self._shapes) do
        shape:move((self._rects[i] - shape:center()):split())
    end
end

function Board:resize()
    self._layout:resize()
end
