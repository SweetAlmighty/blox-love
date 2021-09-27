MainMenu = State:extend()

local function quit() love.event.quit() end
local function start_game() state_machine:push(GameStates.Gameplay) end

function MainMenu:new()
    self._menu = Menu()
    self._menu:set_offset(0, -45)
    self._menu:set_background(30, 85, 260, 150)
    self._menu:set_start(MenuQuadrants.BottomMiddle)
    self._menu:add_item({ name = "Start Game", action = start_game })
    self._menu:add_item({ name = "Quit", action = quit })
	self._name = love.graphics.newText(titleFont, "BLOX")
end

function MainMenu:enter()
	print("Entering Main Menu")
end

function MainMenu:exit()
	print("Exiting Main Menu")
end

function MainMenu:draw()
	love.graphics.setColor(1, 1, 1)
	self._menu:draw()
	love.graphics.draw(self._name, 100, 100)
end

function MainMenu:input(key)
	self._menu:input(key)
end

function MainMenu:update(dt)
	self._menu:update(dt)
end
