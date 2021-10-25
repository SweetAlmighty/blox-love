MainMenu = State:extend()

function MainMenu:new()
    MainMenu.super.new(self)
  	self._layout = gooi.newPanel({x = 0, y = 0, w = 1280, h = 720, layout = "grid 5x3"})
  	self._layout:add(gooi.newLabel({text = "BLOX"}):center(), "1,2")
  	self._layout:add(gooi.newButton({text = "PLAY", y=100})
  		:center()
  		:onRelease(function() state_machine:push(GameStates.Gameplay) end), "3,2")
  	self._layout:add(gooi.newButton({text = "EXIT", y=200})
  		:center()
  		:onRelease(love.event.quit), "4,2")
end

function MainMenu:input(key) end
function MainMenu:update(dt) end
function MainMenu:enter() self._layout:setVisible(true) end
function MainMenu:pause() self._layout:setVisible(false) end
function MainMenu:draw() love.graphics.setColor(1, 1, 1) end
function MainMenu:unpause() self._layout:setVisible(true) end
