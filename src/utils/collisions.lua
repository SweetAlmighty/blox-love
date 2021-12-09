local Utils = require "src/utils/utils"
local Block = require "src/board/block"

local Collisions = { }

local _block = nil
local remove = { }
local collisions = { }
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
        v:collision_enter(_block)
        _block:collision_enter(v)
    end
end

local function find_collisions_to_remove(i, v)
    if Utils.find_index(collisions, v) == nil then
        remove[#remove+1] = v
    end
end

local function process_obsolete_collisions(i, v)
    v:collision_exit(_block)
    _block:collision_exit(v)
end

local function handle_collisions(block)
    _block = block
    block_collisions = block:collisions()

    -- Process new collisions
    Utils.for_each(collisions, process_new_collisions)

    -- Find collisions to remove
    Utils.for_each(block_collisions, find_collisions_to_remove)

    -- Process collisions that are no longer valid
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
