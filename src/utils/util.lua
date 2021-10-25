function distance(p1, p2)
    local dx = p1.x - p2.x
    local dy = p1.y - p2.y
    local s = dx * dx + dy * dy
    return squared and s or math.sqrt(s)
end

function shuffle(list)
    local shuffled = {}
    for _, v in ipairs(list) do
        local pos = math.random(1, #shuffled + 1)
        table.insert(shuffled, pos, v)
    end
    return shuffled
end

function find_index(table, entry)
    for i = 1, #table, 1 do if table[i] == entry then return i end end
return nil
end

function wipe(table)
    for i = 1, #table, 1 do
        table[i] = nil
    end
end

function move(tbl, new, old)
    table.insert(tbl, new, table.remove(tbl, old))
end
