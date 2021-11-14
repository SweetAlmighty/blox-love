State = Object:extend()

local lg = love.graphics

function State:draw()
    lg.clear(lg.getBackgroundColor())
end

function State:new() end
function State:enter() end
function State:exit() end
function State:pause() end
function State:unpause() end
function State:resize() end
function State:input(key) end
function State:update(dt) end
function State:mouse_moved(x, y, dx, dy, istouch) end
function State:mouse_pressed(x, y, button, istouch, presses) end
function State:mouse_released(x, y, button, istouch, presses) end
