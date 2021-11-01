require "src/ui/gameui"
require "src/board/board"

Gameplay = State:extend()

local gameui = nil
local paused = false

local function togglePause()
    paused = not paused
end

local function resetBoard(self)
    togglePause()
    self._board:reset()
    gameui:resetClicked()
end

local function onGridComplete(self)
    paused = not paused
    self._win:play()
    UI.createModal("SUCCESS!", "alert", function()
        resetBoard(self)
    end)
end

function Gameplay:new()
    self._board = Board()

    gameui = GameUI(function()
        if paused then state_machine:pop() else
            state_machine:push(GameStates.Pause)
        end
    end)

    self._board:setOnGridComplete(function()
        onGridComplete(self)
    end)

    self._win = Resources.LoadSFX('Win sound 6')
    self._music = Resources.LoadMusic('Casual - Level 2 (Loop_01)')
end

function Gameplay:enter()
    gameui:setVisible(true)
    self._music:play_looping()
end

function Gameplay:exit()
    self._music:stop()
    gameui:setVisible(false)
end

function Gameplay:draw()
    Gameplay.super.draw()
    self._board:draw()
end

function Gameplay:pause() paused = true end

function Gameplay:unpause() paused = false end

function Gameplay:update(dt)
    if not paused then self._board:update(dt) end
end

function Gameplay:resize() self._board:resize() end

function Gameplay:mousemoved(x, y, dx, dy, istouch)
    if not paused then self._board:mouse_moved(dx, dy) end
end

function Gameplay:mousepressed(x, y, button, istouch, presses)
    if not paused then self._board:mouse_pressed(x, y) end
end

function Gameplay:mousereleased(x, y, button, istouch, presses)
    if not paused then self._board:mouse_released() end
end
