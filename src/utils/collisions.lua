local remove = { }
local collisions = { }

local function check_collision(a, b)
    local one = a:translation()
    local two = b:translation()

    return one.x < two.x + Block.width and
           two.x < one.x + Block.width and
           one.y < two.y + Block.height and
           two.y < one.y + Block.height
end

local function handle_collisions(block, collisions)
    local block_collisions = block:collisions()

    -- Process new collisions
    for_each(collisions, function(i, v)
        if find_index(block_collisions, v) == nil then
            -- Enter
            v:collision_enter(block)
            block:collision_enter(v)
        end
    end)

    -- Find collisions to remove
    for_each(block_collisions, function(i, v)
        if find_index(collisions, v) == nil then
            remove[#remove+1] = v
        end
    end)

    -- Process collisions that are no longer valid
    for_each(remove, function(i, v)
        v:collision_exit(block)
        block:collision_exit(v)
    end)

    wipe(remove)
end

function check_collisions(blocks)
    for_each(blocks, function(i, v)
        for_each(blocks, function(j, w)
            if i ~= j and (v:type() ~= w:type()) then
                if check_collision(v, w) then
                    collisions[#collisions+1] = w
                end
            end
        end)

        handle_collisions(v, collisions)

        wipe(collisions)
    end)
end