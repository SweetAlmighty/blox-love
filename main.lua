require "src/lib/gooi"
local Utils = require "src/utils/utils"
local Object = require "src/lib/classic"
local Resources = require "src/utils/resources"
local StateMachine = require "src/states/statemachine"

function love.load()
    Utils.seed_rand()
    Resources.load()
    state_machine = StateMachine()
end

function love.draw() state_machine:draw() end
function love.resize() state_machine:resize() end
function love.update(dt) state_machine:update(dt) end
function love.keypressed(key) state_machine:input(key) end
function love.mousemoved(x, y, dx, dy, istouch) state_machine:mouse_moved(x, y, dx, dy, istouch) end
function love.mousepressed(x, y, button, istouch, presses) state_machine:mouse_pressed(x, y, button, istouch, presses) end
function love.mousereleased(x, y, button, istouch, presses) state_machine:mouse_released(x, y, button, istouch, presses) end
