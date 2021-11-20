local Object = require "src/lib/classic"

local Coordinate = Object:extend()

function Coordinate:new(column, row)
    self.row = row
    self.column = column
end

function Coordinate.__tostring(c)
    return "Coordinate(" .. c.column .. ", " .. c.row.. ")"
end

function Coordinate.__add(lhs, rhs)
    return Coordinate(lhs.column + rhs.column, lhs.row + rhs.row)
end

function Coordinate.__sub(lhs, rhs)
    return Coordinate(lhs.column - rhs.column, lhs.row - rhs.row)
end

return Coordinate
