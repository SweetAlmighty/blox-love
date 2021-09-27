require "src/utils/coordinate"

Block = Object:extend()

Block.width = 53
Block.height = 53

function Block:new(column, row)
	self._coordinates = Coordinate(column, row)
end

function Block:row()
    return self._coordinates.row
end

function Block:column()
    return self._coordinates.column
end
