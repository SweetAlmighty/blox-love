Shape = Object:extend()

local color_index = 1

local function get_block(pos)
    if pos.row > 0 and pos.row <= Grid.rows then
        if pos.column > 0 and pos.column <= Grid.columns then
            return Grid.blocks[pos.column][pos.row]
        end
    end
end

local function set_grid_block_colors(self, snappable)
    foreach(self._snap_points, function(i, v) v:set_base_color(snappable) end)
end

local function set_grid_blocks_occupied_state(self)
    foreach(self._snap_points, function(i, v) v:set_occupied(self._snapped) end)
end

local function valid_collisions(self)
    local collisions = {}
    foreach(self._blocks, function(i,v)
        if #v:get_collisions() > 0 then
            collisions[#collisions + 1] = true
        end
    end)
    return #collisions == #self._blocks
end

local function determine_snap_points(self)
    set_grid_block_colors(self, false)

    self._snap_points = {}

    if valid_collisions(self) then
        for _, snap_block in ipairs(self._blocks[1]:get_snap_blocks()) do
            for _, block in ipairs(self._blocks) do
                local next = get_block(snap_block._coordinates + (block._coordinates - self._blocks[1]._coordinates))

                if next == 'nil' or next == nil or next:is_occupied() then
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

function Shape:new(blocks)
    self._scale = 1
    self._snapped = false
    self._blocks = blocks
    self._snap_points = {}
    self._color = Color.colors[color_index]
    self._transform = love.math.newTransform()
    self._sprite_batch = love.graphics.newSpriteBatch(Block.texture)
    color_index = color_index == #Color.colors and 1 or color_index + 1

    foreach(self._blocks, function(i,v)
        local coords = v:coords() - blocks[1]:coords()
        v._position = Vector(coords.column * Block.width, coords.row * Block.height)
    end)

    foreach(self._blocks, function(i,v) v:set_color(self._color) end)
end

function Shape:block_count() return #self._blocks end

function Shape:get_block(index) return self._blocks[index] end

function Shape:attempt_snap() return valid_collisions(self) end

function Shape:draw()
    self._sprite_batch:clear()

    self._sprite_batch:setColor(self._color.r, self._color.g, self._color.b)
    foreach(self._blocks, function(i, v)
        local pos = v:get_translation()
        self._sprite_batch:add(pos.x, pos.y, 0, self._scale, self._scale)
    end)

    love.graphics.draw(self._sprite_batch)
end

function Shape:move(dx, dy)
    self._transform = self._transform:translate(dx/self._scale, dy/self._scale)

    foreach(self._blocks, function(i, v)
        v:set_translation(self._transform:transformPoint(v._position.x, v._position.y))
    end)

    determine_snap_points(self)
end

function Shape:snap()
    self._snapped = #self._snap_points == #self._blocks

    if self._snapped then
        local dif = self._snap_points[1]:get_translation() - self._blocks[1]:get_translation()
        self:move(dif.x, dif.y)
        foreach(self._snap_points, function(i, v) v:set_occupied(true) end)
    end

    set_grid_blocks_occupied_state(self)
end

function Shape:unsnap()
    if self._snapped then
        foreach(self._blocks, function(i,v) v:unsnap() end)
        self._snapped = false
    end
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
    foreach(self._blocks, function(i, v) pos = pos + v:get_center() end)
    return pos / #self._blocks
end
