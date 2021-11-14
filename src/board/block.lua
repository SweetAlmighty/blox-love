require "src/utils/coordinate"

Block = Object:extend()

Block.texture = Resources.load_image('block')

Block.width = Block.texture:getWidth()
Block.height = Block.texture:getHeight()

function Block:coords() return self._coordinates end

function Block:row() return self._coordinates.row end

function Block:column() return self._coordinates.column end

function Block:new(column, row) self._coordinates = Coordinate(column, row) end
