local remove = { }
local collisions = { }

local function check_collision(a, b)
    local one = a:get_position()
    local two = b:get_position()

    return one.x < two.x + Block.width and
           two.x < one.x + Block.width and
           one.y < two.y + Block.height and
           two.y < one.y + Block.height
end

local function handle_collisions(block, collisions)
    local block_collisions = block:get_collisions()

    -- Process new collisions
    for i=1, #collisions, 1 do
        local index = find_index(block_collisions, collisions[i])
        if index == nil then
            -- Enter
            collisions[i]:collision_enter(block)
            block:collision_enter(collisions[i])
        end
    end

    -- Find collisions to remove
    for i=1, #block_collisions, 1 do
        local index = find_index(collisions, block_collisions[i])
        if index == nil then
            remove[#remove+1] = block_collisions[i]
        end
    end

    -- Process collisions that are no longer valid
    for i=1, #remove, 1 do
        -- Exit
        remove[i]:collision_exit(block)
        block:collision_exit(remove[i])
    end

    wipe(remove)
end

function check_collisions(blocks)
    for i=1, #blocks, 1 do
        for j=1, #blocks, 1 do
            if i ~= j and (blocks[i]._type ~= blocks[j]._type) then
                if check_collision(blocks[i], blocks[j]) then
                    collisions[#collisions+1] = blocks[j]
                end
            end
        end

        handle_collisions(blocks[i], collisions)
        
        wipe(collisions)
    end
end