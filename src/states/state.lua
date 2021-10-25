State = Object:extend()

function State:new()
	self._back = Resources.LoadSFX('Go back sounds 5')
	self._forward = Resources.LoadSFX('Go forward sounds 1')
end

function State:enter()
	self._forward:play()
end

function State:exit()
	self._back:play()
end

function State:pause()
end

function State:unpause()
end

function State:draw()
end

function State:input(key)
end

function State:update(dt)
end

function State:mousemoved(x, y, dx, dy, istouch)
end

function State:mousepressed(x, y, button, istouch, presses)
end

function State:mousereleased(x, y, button, istouch, presses)
end

function State:resize()
end