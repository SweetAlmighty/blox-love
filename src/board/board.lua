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
    --self._selected_shape:move(0, -100)
end

local function deselect_shape(self)
    self._shape_interaction:play()

    if self._selected_shape:attempt_snap() then
        self._selected_shape:snap()
    else
        local index = find_index(self._shapes, self._selected_shape)
        local delta = self._rects[index].center - self._shapes[index]:center()
        self._selected_shape:move(delta.x, delta.y)
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

    local coord = nil
    local shape = {}
    for i, v in pairs(shapes) do
        shape = {}
        for j, z in pairs(v) do
            coord = z._coordinates
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

    love.graphics.setColor(0, 1, 0)
    for i = 1, #self._rects do
        love.graphics.rectangle("line", self._rects[i].pos.x, self._rects[i].pos.y, self._rects[i].size.x, self._rects[i].size.y)
    end
    love.graphics.setColor(1, 1, 1)

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

    for i = 1, columns do
        for j = 1, rows do
            rect = {
                size = size,
                pos = Vector(x + (width * (i - 1)), y + (height * (j - 1)))
            }
            rect.center = rect.pos + (size / 2)

            self._rects[#self._rects + 1] = rect
        end
    end

    local delta
    for i, shape in ipairs(self._shapes) do
        delta = self._rects[i].center - shape:center()
        shape:move(delta.x, delta.y)
    end
end

function Board:resize()
    self._layout:resize()
end
