local UI = require "src/ui/ui"
local Utils = require "src/utils/utils"
local Board = require "src/board/board"
local State = require "src/states/state"
local Resources = require "src/utils/resources"

local Gameplay = State:extend()

local draw = love.graphics.draw

function Gameplay:new()
    self._pause = false
    self._type = State.GameStates.Gameplay
    self._win = Resources.load_sfx('Win sound 6')
    self._background = Resources.load_image('scifi_main_menu')

    local on_win = function()
        self._pause = false
        self._board:regen()
    end

    local function show_settings(visible)
        self._settings:setVisible(visible)
    end

    local on_complete = function()
        self._win:play()
        self._pause = true
        UI.grid_complete_modal(on_win)
    end

    local on_regen = function() self._board:regen() end
    local on_reset = function() self._board:reset() end

    self._draw = function()
        draw(self._background, 0, 0)
        self._board:draw()
    end

    self._is_paused = function()
        return self._settings.visible or self._pause
    end

    self._board = Board(on_complete)
    self._ui = UI.game_ui(show_settings)
    self._settings = UI.game_settings(on_reset, on_regen)
end

function Gameplay:draw()
    if self._is_paused() then Utils.blur(self._draw)
    else self._draw() end
end

function Gameplay:update(dt)
    if not self._is_paused() then self._board:update(dt) end
end

function Gameplay:mouse_moved(x, y, dx, dy, istouch)
    if not self._is_paused() then self._board:mouse_moved(dx, dy) end
end

function Gameplay:mouse_pressed(x, y, button, istouch, presses)
    if not self._is_paused() and button == 1 then self._board:mouse_pressed(x, y) end
end

function Gameplay:mouse_released(x, y, button, istouch, presses)
    if not self._is_paused() and button == 1 then self._board:mouse_released() end
end

function Gameplay:type() return self._type end
function Gameplay:resize() self._board:resize() end

return Gameplay
