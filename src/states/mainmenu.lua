local UI = require "src/ui/ui"
local State = require "src/states/state"
local Resources = require "src/utils/resources"

local MainMenu = State:extend()

local function on_exit()
    Resources.save()
    love.event.quit()
end

local function on_play_released() state_machine:push(GameStates.Gameplay) end

local function on_exit_released() UI.create_modal("Exit Blox?", "modal", on_exit) end

function MainMenu:new()
    MainMenu.super.new(self)
    self._layout = UI.create_panel("BLOX", {x = 0, y = 0, w = love.graphics.getWidth(), h = love.graphics.getHeight()}, "grid", 5, 3)
    self._layout:add(UI.create_button("PLAY", nil, on_play_released), "3,2")
    self._layout:add(UI.create_button("EXIT", nil, on_exit_released), "4,2")
end

function MainMenu:enter() self._layout:setVisible(true) end
function MainMenu:pause() self._layout:setVisible(false) end
function MainMenu:unpause() self._layout:setVisible(true) end

return MainMenu
