local Object = require "src/lib/classic"
local State = require "src/states/state"
local Gameplay = require "src/states/gameplay"
local MainMenu = require "src/states/mainmenu"
local Resources = require "src/utils/resources"
local SplashScreen = require "src/states/splashscreen"

local StateMachine = Object:extend()

function StateMachine:new()
    self._stack = { MainMenu() }
    self._stack[#self._stack]:enter()
    self._draw_previous_state = function() self._stack[#self._stack-1]:draw() end
end

function StateMachine:pop()
    if #self._stack ~= 0 then
        self._stack[#self._stack]:exit()
        self._stack[#self._stack] = nil

        if #self._stack ~= 0 then
            self._stack[#self._stack]:unpause()
        end
    end
end

function StateMachine:push(type)
    local state = nil
    if type == State.GameStates.SplashScreen then state = SplashScreen()
    elseif type == State.GameStates.MainMenu then state = MainMenu()
    elseif type == State.GameStates.Gameplay then state = Gameplay()
    end

    if state then
        if #self._stack ~= 0 then
            self._stack[#self._stack]:pause()
        end

        table.insert(self._stack, state)
        self._stack[#self._stack]:enter()
    end
end

function StateMachine:count() return #self._stack end
function StateMachine:draw() self._stack[#self._stack]:draw() end
function StateMachine:update(dt) self._stack[#self._stack]:update(dt) end
function StateMachine:resize(w, h) self._stack[#self._stack]:resize() end
function StateMachine:input(key) self._stack[#self._stack]:input(key) end
function StateMachine:clear() while(#self._stack > 1) do self:pop() end end
function StateMachine:mouse_moved(x, y, dx, dy, istouch) self._stack[#self._stack]:mouse_moved(x, y, dx, dy, istouch) end
function StateMachine:mouse_pressed(x, y, button, istouch, presses) self._stack[#self._stack]:mouse_pressed(x, y, button, istouch, presses) end
function StateMachine:mouse_released(x, y, button, istouch, presses) self._stack[#self._stack]:mouse_released(x, y, button, istouch, presses) end

return StateMachine
