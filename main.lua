Object = require "src/lib/classic"

require "src/lib/gooi"
require "src/utils/util"
require "src/utils/input"
require "src/utils/resources"
require "src/utils/color"
require "src/states/statemachine"

screen_width = 1280
screen_height = 720

state_machine = StateMachine()

local style = {
    showBorder = false,
    bgColor = { 0.5, 0.5, 1 },
    font = Resources.LoadFont("Uni Sans Heavy", 40)
}

function love.load()
    math.randomseed((os.time()))
    gooi.setStyle(style)
    gooi.desktopMode()
    Resources.Load()
    state_machine:push(GameStates.MainMenu)
end

function love.keypressed(key)
    state_machine:input(key)
end

function love.draw()
    state_machine:draw()
    gooi.draw()
end

function love.update(dt)
    gooi.update(dt)
    state_machine:update(dt)
end

function love.mousemoved(x, y, dx, dy, istouch)
    gooi.moved()
    state_machine:mousemoved(x, y, dx, dy, istouch)
end

function love.mousepressed(x, y, button, istouch, presses)
    gooi.pressed()
    state_machine:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    gooi.released()
    state_machine:mousereleased(x, y, button, istouch, presses)
end

function love.resize()
    state_machine:resize()
end
