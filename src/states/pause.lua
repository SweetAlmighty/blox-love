require "src/ui/pauseui"

Pause = State:extend()

function Pause:enter()
    self.ui:setVisible(true)
    love.graphics.setColor(0.25, 0.25, 0.25, 0.5)
    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight()) -- back buffer
    love.graphics.present()
    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight()) -- front buffer
end
function Pause:draw() end
function Pause:pause() end
function Pause:unpause() end
function Pause:input(key) end
function Pause:update(dt) end
function Pause:exit() self.ui:setVisible(false) end
function Pause:new() self.ui = PauseUI()--[[reset, reset)]] end
