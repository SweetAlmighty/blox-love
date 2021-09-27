require "src/board/board"

Gameplay = State:extend()

local function draw_reset_button()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('line', 50, 1, 100, 30)
    love.graphics.print('Reset', 51, 2)
end

function Gameplay:new()
	self._board = Board()
    self._music = Resources.LoadMusic('Casual - Level 2 (Loop_01)')
end

function Gameplay:enter()
	print("Entering Gameplay")
    self._music:play_looping()
end

function Gameplay:exit()
	print("Exiting Gameplay")
    --self._music:stop()
end

function Gameplay:draw()
    self._board:draw()
    draw_reset_button()
end

function Gameplay:input(key)
end

function Gameplay:update(dt)
    self._board:update(dt)
end

function Gameplay:mousemoved(x, y, dx, dy, istouch)
    self._board:mouse_moved(dx,dy)
end

function Gameplay:mousepressed(x, y, button, istouch, presses)
    if x >= 50 and x <= 150 and y > 1 and y < 30 then
        self._board:reset()
    end

    self._board:mouse_pressed(x,y)
end

function Gameplay:mousereleased(x, y, button, istouch, presses)
    self._board:mouse_released()
end

function Gameplay:resize()
	self._board:resize()
end