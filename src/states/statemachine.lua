require "src/states/state"
require "src/states/gameplay"
require "src/states/mainmenu"

GameStates = { SplashScreen = 1, MainMenu = 2, Gameplay = 3, Pause = 4 }

StateMachine = Object:extend()

function StateMachine:new()
    self.stack = { }
end

function StateMachine:pop()
    self.stack[#self.stack]:exit()
    self.stack[#self.stack] = nil
end

function StateMachine:push(type)
    local state = nil
    if type == GameStates.Gameplay then state = Gameplay()
    elseif type == GameStates.SplashScreen then state = SplashScreen()
    elseif type == GameStates.MainMenu then state = MainMenu()
    elseif type == GameStates.Pause then state = Pause()
    end

    if state then
        table.insert(self.stack, state)
        self.stack[#self.stack]:enter()
    end
end

function StateMachine:count() return #self.stack end
function StateMachine:draw() self.stack[#self.stack]:draw() end
function StateMachine:input(key) self.stack[#self.stack]:input(key) end
function StateMachine:update(dt) self.stack[#self.stack]:update(dt) end
function StateMachine:clear() while(#self.stack > 1) do StateMachine:pop() end end
function StateMachine:mousemoved(x, y, dx, dy, istouch) self.stack[#self.stack]:mousemoved(x, y, dx, dy, istouch) end
function StateMachine:mousepressed(x, y, button, istouch, presses) self.stack[#self.stack]:mousepressed(x, y, button, istouch, presses) end
function StateMachine:mousereleased(x, y, button, istouch, presses) self.stack[#self.stack]:mousereleased(x, y, button, istouch, presses) end
