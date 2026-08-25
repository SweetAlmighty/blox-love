local Object = require "src/lib/classic"

local State = Object:extend()

State.GameStates = { SplashScreen = 1, MainMenu = 2, Gameplay = 3, Settings = 4 }

function State:new() end
function State:draw() end
function State:exit() end
function State:enter() end
function State:pause() end
function State:resize() end
function State:unpause() end
function State:input(key) end
function State:update(dt) end
function State:mouse_moved(x, y, dx, dy, istouch) end
function State:mouse_pressed(x, y, button, istouch, presses) end
function State:mouse_released(x, y, button, istouch, presses) end

return State
