local Pusher = require "src/utils/pusher" -- Pusher has to come first, because it overrides some love functions.
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

function love.draw()
    Pusher.start()
        state_machine:draw()
        gooi.draw()
    Pusher.finish()
end

function love.resize(w, h)
    Pusher.resize(w, h)
    state_machine:resize(w, h)
end

function love.mousemoved(x, y, _dx, _dy, istouch)
    local _x, _y, dx, dy = Pusher.toGame(x, y)
    gooi.moved(_, _x, _y)
    state_machine:mouse_moved(_x, _y, dx, dy, istouch)
end

function love.mousepressed(x, y, button, istouch, presses)
    local _x, _y = Pusher.toGame(x, y)
    gooi.pressed(_, _x, _y)
    state_machine:mouse_pressed(_x, _y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    local _x, _y = Pusher.toGame(x, y)
    gooi.released(_, _x, _y)
    state_machine:mouse_released(_x, _y, button, istouch, presses)
end

function love.update(dt) state_machine:update(dt) end
function love.keypressed(key) state_machine:input(key) end

-- Overriding to avoid double processing touch inputs
function love.touchmoved(x, y, _dx, _dy, istouch) end
function love.touchpressed(x, y, button, istouch, presses) end
function love.touchreleased(x, y, button, istouch, presses) end
