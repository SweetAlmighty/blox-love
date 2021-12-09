local Utils = require "src/utils/utils"
local Block = require "src/board/block"

local Collisions = { }

local remove = { }
local collisions = { }
local local_block = nil
local block_collisions = { }

local function check_collision(a, b)
    local one = a:translation()
    local two = b:translation()

    return one.x < two.x + Block.width and
           two.x < one.x + Block.width and
           one.y < two.y + Block.height and
           two.y < one.y + Block.height
end

local function process_new_collisions(i, v)
    if Utils.find_index(block_collisions, v) == nil then
        v:collision_enter(local_block)
        local_block:collision_enter(v)
    end
end

local function find_collisions_to_remove(i, v)
    if Utils.find_index(collisions, v) == nil then
        remove[#remove+1] = v
    end
end

local function process_obsolete_collisions(i, v)
    v:collision_exit(local_block)
    local_block:collision_exit(v)
end

local function handle_collisions(block)
    local_block = block
    block_collisions = block:collisions()

    Utils.for_each(collisions, process_new_collisions)
    Utils.for_each(block_collisions, find_collisions_to_remove)
    Utils.for_each(remove, process_obsolete_collisions)

    Utils.wipe(remove)
end

function Collisions.check_collisions(blocks)
    for i, v in ipairs(blocks) do
        for j, w in ipairs(blocks) do
            if i ~= j and (v:type() ~= w:type()) then
                if check_collision(v, w) then
                    collisions[#collisions+1] = w
                end
            end
        end

        handle_collisions(v)

        Utils.wipe(collisions)
    end
end

return Collisions
