local Utils = require "src/utils/utils"
local Object = require "src/lib/classic"
local State = require "src/states/state"
local Settings = require "src/states/settings"
local Gameplay = require "src/states/gameplay"
local MainMenu = require "src/states/mainmenu"
local Resources = require "src/utils/resources"
local SplashScreen = require "src/states/splashscreen"

GameStates = { SplashScreen = 1, MainMenu = 2, Gameplay = 3, Settings = 4 }

local StateMachine = Object:extend()

function StateMachine:new()
    self._stack = { }
    self._back = Resources.load_sfx('Go back sounds 5')
    self._forward = Resources.load_sfx('Go forward sounds 1')
    self._draw_previous_state = function() self._stack[#self._stack-1]:draw() end
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
    elseif type == GameStates.SplashScreen then state = SplashScreen()
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

function StateMachine:draw()
    if #self._stack > GameStates.MainMenu then
        Utils.blur(self._draw_previous_state)
    end

    self._stack[#self._stack]:draw()
    gooi.draw()
end

function StateMachine:update(dt)
    gooi.update(dt)
    self._stack[#self._stack]:update(dt)
end

function StateMachine:mouse_moved(x, y, dx, dy, istouch)
    gooi.moved()
    self._stack[#self._stack]:mouse_moved(x, y, dx, dy, istouch)
end

function StateMachine:mouse_pressed(x, y, button, istouch, presses)
    gooi.pressed()
    self._stack[#self._stack]:mouse_pressed(x, y, button, istouch, presses)
end

function StateMachine:mouse_released(x, y, button, istouch, presses)
    gooi.released()
    self._stack[#self._stack]:mouse_released(x, y, button, istouch, presses)
end

function StateMachine:count() return #self._stack end
function StateMachine:resize() self._stack[#self._stack]:resize() end
function StateMachine:input(key) self._stack[#self._stack]:input(key) end
function StateMachine:clear() while(#self._stack > 1) do self:pop() end end

return StateMachine
