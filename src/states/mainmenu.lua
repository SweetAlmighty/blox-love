local UI = require "src/ui/ui"
local State = require "src/states/state"
local Resources = require "src/utils/resources"
local MenuBackground = require "src/menubackground"

local MainMenu = State:extend()

local getWidth = love.graphics.getWidth
local getHeight = love.graphics.getHeight

local function on_exit()
    Resources.save()
    love.event.quit()
end

local function on_play_released() state_machine:push(GameStates.Gameplay) end
local function on_exit_released() UI.create_modal("Exit Blox?", "modal", on_exit) end

function MainMenu:new()
    MainMenu.super.new(self)
    self._menu_background = MenuBackground()
    self._music = Resources.load_music('This should be Funny')
    self._layout = UI.create_panel("BLOX", {x = 0, y = 0, w = getWidth(), h = getHeight()}, "grid", 5, 3)
    self._layout:add(UI.create_button("PLAY", nil, on_play_released), "3,2")
    self._layout:add(UI.create_button("EXIT", nil, on_exit_released), "4,2")
end

function MainMenu:update(dt)
    self._menu_background:update()
end

function MainMenu:draw()
    MainMenu.super.draw()
    self._menu_background:draw()
end

function MainMenu:mouse_moved(x, y, dx, dy, istouch)
    self._menu_background:mouse_moved(x, y, dx, dy, istouch)
end

function MainMenu:pause()
    self._layout:setVisible(false)
    self._menu_background:unpause()
end

function MainMenu:unpause()
    self._layout:setVisible(true)
    self._menu_background:unpause()
end

function MainMenu:enter()
    self._music:play_looping()
    self._layout:setVisible(true)
end

return MainMenu
