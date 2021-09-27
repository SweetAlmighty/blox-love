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
    self._selected_shape:move(0, -100)
end

local function deselect_shape(self)
    self._shape_interaction:play()
    self._selected_shape:attempt_snap()
    self._selected_shape = nil
end

function Board:new()
    self._shapes = { }
    self._layout = Layout()
    self._grid = Grid(self._layout:get_grid_center())

    self._shape_interaction = Resources.LoadSFX("Switch sounds 1")

    self:create_shapes()
    self:place_shapes()
end

function Board:create_shapes()
    local shapes = self._grid:get_shapes()

    local coord = nil
    local shape = { }
    for i,v in pairs(shapes) do
        shape = { }
        for j,z in pairs(v) do
            coord = z._coordinates
            shape[#shape+1] = ShapeBlock(coord.column, coord.row)
        end
        self._shapes[#self._shapes+1] = Shape(shape)
    end
end

function Board:reset()
    -- Reset grid here
    wipe(self._shapes)
    wipe(CollidableBlock.blocks)
    
    self._grid = Grid(self._layout:get_grid_center())
    
    self:create_shapes()
    self:place_shapes()
    self._selected_shape = nil
end

function Board:update(dt)
    -- Needs to be a list containing all non-gap grid blocks and all shape blocks
    check_collisions(CollidableBlock.blocks)
    if self._grid:is_complete() then
        self:reset()
    end
end

function Board:draw()
    self._layout:draw()
    self._grid:draw()
    for i=#self._shapes, 1, -1 do
        self._shapes[i]:draw()
    end
end

function Board:mouse_moved(dx,dy)
    if self._selected_shape then
        self._selected_shape:move(dx,dy)
    end
end

function Board:mouse_pressed(x,y)   
    for i=1, #self._shapes, 1 do
        if self._shapes[i]:selected(x,y) then
            select_shape(self, self._shapes[i])
            move(self._shapes, 1, i)
            return
        end
    end
end

function Board:mouse_released(x,y)
    if self._selected_shape then
        deselect_shape(self)
    end
end

function Board:place_shapes()
    local pos = nil
    local randomized_shapes = shuffle(self._shapes)
    local width, height = love.graphics.getDimensions()

    for i=1, #randomized_shapes, 1 do
        local shape = randomized_shapes[i]

        pos = shape:get_block(1):get_position()
        local dx = math.random(Block.width, width - Block.width) - pos.x
        local dy = math.random(Block.height * 6, height - Block.height) - pos.y

        for j=1, shape:block_count(), 1 do
            pos = shape:get_block(j):get_position()
            shape:get_block(j):set_position(pos.x + dx, pos.y + dy)
        end
    end
end

function Board:resize()
    self._layout:resize()
end