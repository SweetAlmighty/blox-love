Object = require "src/lib/classic"

require "src/lib/gooi"
require "src/utils/util"
require "src/utils/input"
require "src/utils/resources"
require "src/utils/color"
require "src/states/statemachine"
require "src/ui/ui"

state_machine = StateMachine()

function love.load()
    math.randomseed(os.time() + tonumber(tostring({}):sub(8)))

    Resources.Load()
    UI.setStartStyle()
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

function love.run()
    if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local dt = 0

    -- Main loop time.
    return function()
        -- Process events.
        if love.event then
            love.event.pump()
            for name, a,b,c,d,e,f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a or 0
                    end
                end
                love.handlers[name](a,b,c,d,e,f)
            end
        end

        -- Update dt, as we'll be passing it to update
        if love.timer then dt = love.timer.step() end

        -- Call update and draw
        if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()

            -- Commented out so that pause state can show previous state
            --love.graphics.clear(love.graphics.getBackgroundColor())

            if love.draw then love.draw() end

            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end
end