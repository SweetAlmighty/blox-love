MainMenu = State:extend()

local function setVisible(self, value)
	self._play:setVisible(value)
	self._exit:setVisible(value)
	self._title:setVisible(value)
end

function MainMenu:new()
	self._title = gooi.newLabel({text = "BLOX"}):center()

	self._exit = gooi.newButton({text = "EXIT", y=200}):center()
	:onRelease(love.event.quit)

	self._play = gooi.newButton({text = "PLAY", y=100}):center()
	:onRelease(function() state_machine:push(GameStates.Gameplay) end)
end

function MainMenu:exit() end
function MainMenu:input(key) end
function MainMenu:update(dt) end
function MainMenu:enter() setVisible(self, true) end
function MainMenu:pause() setVisible(self, false) end
function MainMenu:unpause() setVisible(self, true) end
function MainMenu:draw() love.graphics.setColor(1, 1, 1) end
