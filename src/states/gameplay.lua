local UI = require "src/ui/ui"
local Utils = require "src/utils/utils"
local Board = require "src/board/board"
local State = require "src/states/state"
local Resources = require "src/utils/resources"

local Gameplay = State:extend()

local draw = love.graphics.draw

function Gameplay:new()
    self._type = State.GameStates.Gameplay
    self._win = Resources.load_sfx('Win sound 6')
    self._background = Resources.load_image('scifi_main_menu')

    local on_win = function() self._win:play() end
    local on_complete = function() UI.grid_complete_modal(on_win) end
    self._board = Board(on_complete)

    local on_regen = function() self._board:regen() end
    local on_reset = function() self._board:reset() end
    self._settings = UI.game_settings(on_reset, on_regen)
    self._ui = UI.game_ui(function(vis) self._settings:setVisible(vis) end)

    self._draw = function()
        draw(self._background, 0, 0)
        self._board:draw()
    end
end

function Gameplay:draw()
    if self._settings.visible then
        Utils.blur(self._draw)
    else
        self._draw()
    end
end

function Gameplay:update(dt)
    Gameplay.super.update(self, dt)
    if not self._settings.visible then self._board:update(dt) end
end

function Gameplay:mouse_moved(x, y, dx, dy, istouch)
    Gameplay.super.mouse_moved(self, x, y, dx, dy, istouch)
    if not self._settings.visible then self._board:mouse_moved(dx, dy) end
end

function Gameplay:mouse_pressed(x, y, button, istouch, presses)
    Gameplay.super.mouse_pressed(self, x, y, button, istouch, presses)
    if not self._settings.visible then self._board:mouse_pressed(x, y) end
end

function Gameplay:mouse_released(x, y, button, istouch, presses)
    Gameplay.super.mouse_released(self, x, y, button, istouch, presses)
    if not self._settings.visible then self._board:mouse_released() end
end

function Gameplay:type() return self._type end

function Gameplay:resize() self._board:resize() end

return Gameplay
