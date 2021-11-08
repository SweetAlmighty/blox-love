Shape = Object:extend()

local color_index = 1

local function get_block(pos)
    if pos.row > 0 and pos.row <= Grid.rows then
        if pos.column > 0 and pos.column <= Grid.columns then
            return Grid.blocks[pos.column][pos.row]
        end
    end
    return nil
end

local function set_grid_block_colors(self, snappable)
    for i = 1, #self._snap_points do
        self._snap_points[i]:set_base_color(snappable)
    end
end

local function set_grid_blocks_occupied_state(self)
    for i = 1, #self._snap_points do
        self._snap_points[i]:set_occupied(self._snapped)
    end
end

local function is_neighbor(lhs, rhs)
    return lhs:column() - 1 == rhs:column() or
    lhs:column() + 1 == rhs:column() or
    lhs:row() - 1 == rhs:row() or
    lhs:row() + 1 == rhs:row()
end

local function determine_snap_points(self)
    set_grid_block_colors(self, false)

    self._snap_points = {}

    local count = 0

    for i = 1, #self._blocks do
        if #self._blocks[i]:get_collisions() > 0 then
            count = count + 1
        end
    end

    if count == #self._blocks then
        local potentialGridBlocks = self._blocks[1]:get_snap_blocks()
        for i = 1, #potentialGridBlocks do
            for j = 1, #self._blocks do
                local pos = potentialGridBlocks[i]._coordinates + (self._blocks[j]._coordinates - self._blocks[1]._coordinates)
                local next = get_block(pos)

                if next == 'nil' or next == nil or next:is_occupied() then
                    self._snap_points = {}
                    break
                end

                self._snap_points[#self._snap_points + 1] = next
            end

            if #self._snap_points ~= 0 then
                break
            end
        end
    end

    set_grid_block_colors(self, true)
end

function Shape:new(blocks)
    self._snapped = false
    self._blocks = blocks
    self._snap_points = {}
    self._color = Color.colors[color_index]
    color_index = color_index == #Color.colors and 1 or color_index + 1

    for i = 1, #self._blocks do
        self._blocks[i]:set_color(self._color)
    end
end

function Shape:draw()
    for i = 1, #self._blocks do
        self._blocks[i]:draw()
    end
end

function Shape:move(dx, dy)
    for i = 1, #self._blocks do
        self._blocks[i]:move(dx, dy)
    end

    determine_snap_points(self)
end

function Shape:get_block(index)
    return self._blocks[index]
end

function Shape:block_count()
    return #self._blocks
end

function Shape:snap()
    self._snapped = #self._snap_points == #self._blocks

    if self._snapped then
        local dif = self._snap_points[1]:get_position() - self._blocks[1]:get_position()
        for i = 1, #self._blocks do self._blocks[i]:move(dif.x, dif.y) end
        for i = 1, #self._snap_points do self._snap_points[i]:set_occupied(true) end
    end
end

function Shape:unsnap()
    if self._snapped then
        for i = 1, #self._blocks do
            self._blocks[i]:unsnap()
        end
        self._snapped = false
    end
end

function Shape:selected(x, y)
    for i = 1, #self._blocks do
        local pos = self._blocks[i]:get_position()
        if x >= pos.x and x < pos.x + Block.width then
            if y >= pos.y and y < pos.y + Block.height then
                return true
            end
        end
    end

    return false
end

function Shape:attempt_snap()
    local collisions = {}
    for i = 1, #self._blocks do
        if #self._blocks[i]:get_collisions() > 0 then
            collisions[#collisions + 1] = true
        end
    end

    if #collisions == #self._blocks then
        self:snap()
    else
        -- move shape back towards finger
        self:move(0, 100)
    end

    set_grid_blocks_occupied_state(self)
end
