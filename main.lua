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

function love.update(dt)
    gooi.update(dt)
    state_machine:update(dt)
end

function love.draw()
    state_machine:draw()
    gooi.draw()
end

function love.resize(w, h)
    state_machine:resize(w, h)
end

function love.mousemoved(x, y, dx, dy, istouch)
    gooi.moved(_, x, y)
    state_machine:mouse_moved(x, y, dx, dy, istouch)
end

function love.mousepressed(x, y, button, istouch, presses)
    gooi.pressed(_, x, y)
    state_machine:mouse_pressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    gooi.released(_, x, y)
    state_machine:mouse_released(x, y, button, istouch, presses)
end

function love.keypressed(key) state_machine:input(key) end

--[[
-- Overriding to avoid double processing touch inputs
function love.touchmoved(x, y, _dx, _dy, istouch) end
function love.touchpressed(x, y, button, istouch, presses) end
function love.touchreleased(x, y, button, istouch, presses) end
]]