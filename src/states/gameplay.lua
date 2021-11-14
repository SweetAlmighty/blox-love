require "src/ui/gameui"
require "src/board/board"

Gameplay = State:extend()

function Gameplay:new()
    self._paused = false
    self._board = Board(function() self:on_grid_complete() end)
    self._gameui = GameUI(function() self:on_settings_clicked() end)

    self._win = Resources.load_sfx('Win sound 6')
    self._music = Resources.load_music('Casual - Level 2 (Loop_01)')
end

function Gameplay:enter()
    self._gameui:set_visible(true)
    self._music:play_looping()
end

function Gameplay:exit()
    self._music:stop()
    self._gameui:set_visible(false)
end

function Gameplay:draw()
    Gameplay.super.draw()
    self._board:draw()
end

local function reset_board(self)
    self._paused = false
    self._board:reset()
    self._gameui:reset_clicked()
end

local function regen_board(self)
    self._paused = false
    self._board:regen()
    self._gameui:reset_clicked()
end

function Gameplay:on_grid_complete()
    self._paused = true
    self._win:play()
    UI.createModal("SUCCESS!", "alert", function()
        regen_board(self)
    end)
end

function Gameplay:on_settings_clicked()
    if self._paused then state_machine:pop() else
        state_machine:push(GameStates.Settings)
    end
end

function Gameplay:pause()
    self._paused = true
    Gameplay.on_regen = function() regen_board(self) end
    Gameplay.on_reset = function() reset_board(self) end
end

function Gameplay:unpause()
    self._paused = false
    Gameplay.on_regen = nil
    Gameplay.on_reset = nil
end

function Gameplay:update(dt)
    if not self._paused then self._board:update(dt) end
end

function Gameplay:resize() self._board:resize() end

function Gameplay:mouse_moved(x, y, dx, dy, istouch)
    if not self._paused then self._board:mouse_moved(dx, dy) end
end

function Gameplay:mouse_pressed(x, y, button, istouch, presses)
    if not self._paused then self._board:mouse_pressed(x, y) end
end

function Gameplay:mouse_released(x, y, button, istouch, presses)
    if not self._paused then self._board:mouse_released() end
end
