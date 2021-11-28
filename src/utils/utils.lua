local Object = require "src/lib/classic"

local Utils = {}

function Utils.distance(p1, p2)
    local dx = p1.x - p2.x
    local dy = p1.y - p2.y
    local s = dx * dx + dy * dy
    return squared and s or math.sqrt(s)
end

function Utils.shuffle(list)
    local shuffled = {}
    Utils.for_each(list, function(i, v)
        local pos = math.random(1, #shuffled + 1)
        table.insert(shuffled, pos, v)
    end)
    return shuffled
end

function Utils.for_each(table, func) for i, v in ipairs(table) do func(i, v) end end
function Utils.move(tbl, new, old) table.insert(tbl, new, table.remove(tbl, old)) end
function Utils.wipe(table) Utils.for_each(table, function(i, v) table[i] = nil end) end
function Utils.seed_rand() math.randomseed(os.time() + tonumber(tostring({}):sub(8))) end
function Utils.find_index(table, entry) for i, v in ipairs(table) do if v == entry then return i end end end

return Utils
