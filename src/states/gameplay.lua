require "src/ui/gameui"
require "src/board/board"

Gameplay = State:extend()

function Gameplay:_onSettingsClicked()
    if self._paused then state_machine:pop() else
        state_machine:push(GameStates.Settings)
    end
end

function Gameplay:new()
    self._paused = false
    self._board = Board(function()
        self:_onGridComplete()
    end)
    self._gameui = GameUI(function()
        self:_onSettingsClicked()
    end)

    self._win = Resources.LoadSFX('Win sound 6')
    self._music = Resources.LoadMusic('Casual - Level 2 (Loop_01)')
end

function Gameplay:enter()
    self._gameui:setVisible(true)
    self._music:play_looping()
end

function Gameplay:exit()
    self._music:stop()
    self._gameui:setVisible(false)
end

function Gameplay:draw()
    Gameplay.super.draw()
    self._board:draw()
end

function Gameplay:_resetBoard()
    self._paused = false
    self._board:reset()
    self._gameui:resetClicked()
end

function Gameplay:_onGridComplete()
    self._paused = true
    self._win:play()
    UI.createModal("SUCCESS!", "alert", function()
        self:_resetBoard()
    end)
end

function Gameplay:pause()
    self._paused = true
    Gameplay.onSkip = function() self:_resetBoard() end
    Gameplay.onReset = function() self:_resetBoard() end
end

function Gameplay:unpause()
    self._paused = false
    Gameplay.onSkip = nil
    Gameplay.onReset = nil
end

function Gameplay:update(dt)
    if not self._paused then self._board:update(dt) end
end

function Gameplay:resize() self._board:resize() end

function Gameplay:mousemoved(x, y, dx, dy, istouch)
    if not self._paused then self._board:mouse_moved(dx, dy) end
end

function Gameplay:mousepressed(x, y, button, istouch, presses)
    if not self._paused then self._board:mouse_pressed(x, y) end
end

function Gameplay:mousereleased(x, y, button, istouch, presses)
    if not self._paused then self._board:mouse_released() end
end
