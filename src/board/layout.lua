local NLay = require "src/lib/nlay"

Layout = Object:extend()

function Layout:new(blocks)
    NLay.update(love.window.getSafeArea())

    self.padding = 40

    local root = NLay
    local insideRoot = NLay.inside(root, self.padding)

    self.grid = insideRoot:constraint(root, root)
                     :size(love.graphics.getWidth()-(200+(self.padding * 2)), love.graphics.getHeight()-(self.padding * 2))

    self.side = insideRoot:constraint(root, self.grid, nil, root)
                     :size(0, love.graphics.getHeight()-(self.padding * 2))
                     :margin({nil, self.padding})
end

function Layout:draw()
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("fill", self.grid:get())
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("fill", self.side:get())
    love.graphics.setColor(0, 0, 0)
end

function Layout:resize()
    NLay.update(love.window.getSafeArea())
end

function Layout:get_grid_rect()
	return self.grid:get()
end

function Layout:get_grid_center()
    local x, y, w, h = self.grid:get()
    return Vector(x + (w/2), y + (h/2))
end

function Layout:get_side_rect()
	return self.side:get()
end