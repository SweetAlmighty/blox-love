local NLay = require "src/lib/nlay"
local Object = require "src/lib/classic"
local Vector = require "src/lib/brinevector"

local Layout = Object:extend()

local lw = love.window
local lg = love.graphics

function Layout:new(blocks)
    NLay.update(lw.getSafeArea())

    self.padding = 65

    local root = NLay
    local insideRoot = NLay.inside(root, self.padding)
    local height = lg.getHeight() - (self.padding * 2)

    self.grid = insideRoot:constraint(root, root)
    :size(lg.getWidth() - (400 + (self.padding * 2)), height)

    self.side = insideRoot:constraint(root, self.grid, nil, root)
    :size(0, height)
    :margin({nil, self.padding})
end

function Layout:draw()
    lg.setColor(0.1, 0.1, 0.1)
    lg.rectangle("fill", self.grid:get())
    lg.rectangle("fill", self.side:get())
    lg.setColor(1, 1, 1)
end

function Layout:get_grid_center()
    local x, y, w, h = self.grid:get()
    return Vector(x + (w / 2), y + (h / 2))
end

function Layout:resize() NLay.update(lw.getSafeArea()) end
function Layout:get_grid_rect() return self.grid:get() end
function Layout:get_side_rect() return self.side:get() end

return Layout
