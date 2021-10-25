require "src/ui/gameui"
require "src/ui/pauseui"
require "src/board/board"

Gameplay = State:extend()

local gameui = nil
local pauseui = nil
local paused = false

local function TogglePause()
    paused = not paused
    pauseui:setVisible(paused)
end

function Gameplay:new()
    Gameplay.super.new(self)
    self._board = Board()

    local function reset()
        TogglePause()
        self._board:reset()
        gameui:resetClicked()
    end

    self._board:setOnGridComplete(function()
        paused = not paused
        self._win:play()
        gooi.alert({
            text = "Success!",
            ok = reset
        })
    end)

    self._win = Resources.LoadSFX('Win sound 6')
    self._music = Resources.LoadMusic('Casual - Level 2 (Loop_01)')

    gameui = GameUI(TogglePause)
    pauseui = PauseUI(reset, reset)
end

function Gameplay:enter()
    Gameplay.super.enter(self)
    gameui:setVisible(true)
    self._music:play_looping()
end

function Gameplay:exit()
    Gameplay.super.exit(self)
    paused = false
    self._music:stop()
    gameui:setVisible(false)
    pauseui:setVisible(false)
end

function Gameplay:input(key) end

function Gameplay:draw()
    self._board:draw()
    if paused then
        pauseui:draw()
    end
end

function Gameplay:resize() self._board:resize() end

function Gameplay:update(dt)
    if not paused then self._board:update(dt) end
end

function Gameplay:mousemoved(x, y, dx, dy, istouch)
    if not paused then self._board:mouse_moved(dx, dy) end
end

function Gameplay:mousepressed(x, y, button, istouch, presses)
    if not paused then self._board:mouse_pressed(x, y) end
end

function Gameplay:mousereleased(x, y, button, istouch, presses)
    if not paused then self._board:mouse_released() end
end
