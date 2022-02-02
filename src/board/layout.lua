local NLay = require "src/lib/nlay"
local Object = require "src/lib/classic"
local Vector = require "src/lib/brinevector"

local Layout = Object:extend()

local setColor = love.graphics.setColor
local getWidth = love.graphics.getWidth
local getHeight = love.graphics.getHeight
local rectangle = love.graphics.rectangle
local getSafeArea = function() return 0, 0, getWidth(), getHeight() end

function Layout:new(blocks)
    NLay.update(getSafeArea())

    self.padding = 65

    local root = NLay
    local insideRoot = NLay.inside(root, self.padding)
    local height = getHeight() - (self.padding * 2)

    self.grid = insideRoot:constraint(root, root)
    :size(getWidth() - ((getHeight()/2) + (self.padding * 2)), height)

    self.side = insideRoot:constraint(root, self.grid, nil, root)
    :size(0, height)
    :margin({nil, self.padding})
end

function Layout:draw()
    setColor(0.1, 0.1, 0.1, 0.3)
    rectangle("fill", self.grid:get())
    rectangle("fill", self.side:get())
    setColor(1, 1, 1)
end

function Layout:get_grid_center()
    local x, y, w, h = self.grid:get()
    return Vector(x + (w / 2), y + (h / 2))
end

function Layout:resize() NLay.update(getSafeArea()) end
function Layout:get_grid_rect() return self.grid:get() end
function Layout:get_side_rect() return self.side:get() end

return Layout
