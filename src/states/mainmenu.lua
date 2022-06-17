local UI = require "src/ui/ui"
local State = require "src/states/state"
local Resources = require "src/utils/resources"
local MenuBackground = require "src/misc/menubackground"

local MainMenu = State:extend()

function MainMenu:new()
    MainMenu.super.new(self)
    self._menu = UI.main_menu()
    self._settings = UI.main_settings()
    self._type = State.GameStates.MainMenu
    self._menu_background = MenuBackground()
    self._music = Resources.load_music('This should be Funny')
    self._ui = UI.game_ui(function(vis)
        self._settings:setVisible(vis)
        self._menu.sons[2].ref:setVisible(not vis)
        --self._menu.sons[3].ref:setVisible(not vis)
    end)
end

function MainMenu:type() return self._type end
function MainMenu:draw() self._menu_background:draw() end
function MainMenu:update(dt) self._menu_background:update() end

function MainMenu:mouse_moved(x, y, dx, dy, istouch)
    self._menu_background:mouse_moved(x, y, dx, dy, istouch)
end

function MainMenu:pause()
    self._ui:setVisible(false)
    self._menu:setVisible(false)
    self._menu_background:unpause()
end

function MainMenu:unpause()
    self._ui:setVisible(true)
    self._menu:setVisible(true)
    self._menu_background:unpause()
end

function MainMenu:enter()
    self._music:play_looping()
    self._ui:setVisible(true)
    self._menu:setVisible(true)
end

return MainMenu
