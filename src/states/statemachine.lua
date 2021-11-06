require "src/states/state"
require "src/states/settings"
require "src/states/gameplay"
require "src/states/mainmenu"

GameStates = { MainMenu = 2, Gameplay = 3, Settings = 4 }

StateMachine = Object:extend()

function StateMachine:new()
    self._stack = { }
    self._back = Resources.LoadSFX('Go back sounds 5')
    self._forward = Resources.LoadSFX('Go forward sounds 1')
end

function StateMachine:pop()
    if #self._stack ~= 0 then
        self._back:play()
        self._stack[#self._stack]:exit()
        self._stack[#self._stack] = nil

        if #self._stack ~= 0 then
            self._stack[#self._stack]:unpause()
        end
    end
end

function StateMachine:push(type)
    local state = nil
    if type == GameStates.Settings then state = Settings()
    elseif type == GameStates.MainMenu then state = MainMenu()
    elseif type == GameStates.Gameplay then state = Gameplay()
    end

    if state then
        if #self._stack ~= 0 then
            self._forward:play()
            self._stack[#self._stack]:pause()
        end

        table.insert(self._stack, state)
        self._stack[#self._stack]:enter()
    end
end

function StateMachine:count() return #self._stack end
function StateMachine:draw() self._stack[#self._stack]:draw() end
function StateMachine:resize() self._stack[#self._stack]:resize() end
function StateMachine:input(key) self._stack[#self._stack]:input(key) end
function StateMachine:update(dt) self._stack[#self._stack]:update(dt) end
function StateMachine:clear() while(#self._stack > 1) do self:pop() end end
function StateMachine:mousemoved(x, y, dx, dy, istouch) self._stack[#self._stack]:mousemoved(x, y, dx, dy, istouch) end
function StateMachine:mousepressed(x, y, button, istouch, presses) self._stack[#self._stack]:mousepressed(x, y, button, istouch, presses) end
function StateMachine:mousereleased(x, y, button, istouch, presses) self._stack[#self._stack]:mousereleased(x, y, button, istouch, presses) end
