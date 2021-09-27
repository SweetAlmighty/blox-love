Object = require "src/lib/classic"

require "src/utils/util"
require "src/utils/resources"

menuFont = Resources.LoadFont("Uni Sans Thin", 15)
titleFont = Resources.LoadFont("Uni Sans Heavy", 50)

require "src/states/menu"
require "src/utils/input"
require "src/utils/color"
require "src/states/statemachine"

screen_width = 800
screen_height = 600

state_machine = StateMachine()

function love.load()
    math.randomseed((os.time()))
    state_machine:push(GameStates.MainMenu)
end

function love.keypressed(key)
    state_machine:input(key)
end

function love.draw()
    state_machine:draw()
end

function love.update(dt)
    state_machine:update(dt)
end

function love.mousemoved(x, y, dx, dy, istouch)
    state_machine:mousemoved(x, y, dx, dy, istouch)
end

function love.mousepressed(x, y, button, istouch, presses)
    state_machine:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    state_machine:mousereleased(x, y, button, istouch, presses)
end

function love.resize()
    state_machine:resize()
end
