require "src/ui/settingsui"

Settings = State:extend()

function Settings:enter()
    self.ui:set_visible(true)
    love.graphics.setColor(0.25, 0.25, 0.25, 0.5)
    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight()) -- back buffer
    love.graphics.present()
    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight()) -- front buffer
end
function Settings:draw() end
function Settings:pause() end
function Settings:unpause() end
function Settings:input(key) end
function Settings:update(dt) end
function Settings:new() self.ui = SettingsUI() end
function Settings:exit() self.ui:set_visible(false) end
