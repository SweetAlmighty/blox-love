State = Object:extend()

function State:draw()
    love.graphics.clear(love.graphics.getBackgroundColor())
end

function State:new() end
function State:enter() end
function State:exit() end
function State:pause() end
function State:unpause() end
function State:resize() end
function State:input(key) end
function State:update(dt) end
function State:mousemoved(x, y, dx, dy, istouch) end
function State:mousepressed(x, y, button, istouch, presses) end
function State:mousereleased(x, y, button, istouch, presses) end
