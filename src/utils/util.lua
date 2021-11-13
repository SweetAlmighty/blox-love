function distance(p1, p2)
    local dx = p1.x - p2.x
    local dy = p1.y - p2.y
    local s = dx * dx + dy * dy
    return squared and s or math.sqrt(s)
end

function shuffle(list)
    local shuffled = {}
    foreach(list, function(i, v)
        local pos = math.random(1, #shuffled + 1)
        table.insert(shuffled, pos, v)
    end)
    return shuffled
end

function find_index(table, entry)
    for i, v in ipairs(table) do if v == entry then return i end end
end

function wipe(table)
    foreach(table, function(i, v) table[i] = nil end)
end

function move(tbl, new, old)
    table.insert(tbl, new, table.remove(tbl, old))
end

function foreach(table, func)
    for i,v in ipairs(table) do func(i, v) end
end
