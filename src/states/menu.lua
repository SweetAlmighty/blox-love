Menu = Object:extend()

MenuAlignments = {
	Left = 1, Center = 2, Right = 2
}

MenuQuadrants = {
	TopLeft    = 1, TopMiddle    = 2, TopRight    = 3,
	MiddleLeft = 4, MiddleMiddle = 5, MiddleRight = 6,
	BottomLeft = 7, BottomMiddle = 8, BottomRight = 9
}

local align = 2
local start = { x = 0, y = 0 }
local background = { x = 0, y = 0, w = 0, h = 0 }

function Menu:new()
	self._width = 0
	self._height = 0
	self._items = { }
	self._selected = 1
	self._offset = { x = 0, y = 0 }
	self._move_sfx = Resources.LoadSFX("Switch sounds 2")
	self._accept_sfx = Resources.LoadSFX("Go back sounds 5")
	self._decline_sfx = Resources.LoadSFX("Go forward sounds 1")
end

function Menu:update(dt) end

function Menu:selected()
	return self._selected
end

function Menu:set_offset(x, y)
	self._offset = { x = x, y = y }
end

function Menu:set_alignment(alignment)
    if     alignment == MenuAlignments.Left   then align = 0
    elseif alignment == MenuAlignments.Center then align = 2
    elseif alignment == MenuAlignments.Right  then align = 1
    end
end

function Menu:set_start(alignment)
	local quad_width = screen_width/3
	local quad_height = screen_height/3

    if     alignment == MenuQuadrants.TopLeft      then start = { x = 0,              y = 0 }
    elseif alignment == MenuQuadrants.TopMiddle    then start = { x = quad_width,     y = 0 }
    elseif alignment == MenuQuadrants.TopRight     then start = { x = quad_width * 2, y = 0 }
    elseif alignment == MenuQuadrants.MiddleLeft   then start = { x = 0,              y = quad_height }
    elseif alignment == MenuQuadrants.MiddleMiddle then start = { x = quad_width    , y = quad_height }
    elseif alignment == MenuQuadrants.MiddleRight  then start = { x = quad_width * 2, y = quad_height }
    elseif alignment == MenuQuadrants.BottomLeft   then start = { x = 0,              y = quad_height * 2 }
    elseif alignment == MenuQuadrants.BottomMiddle then start = { x = quad_width    , y = quad_height * 2 }
    elseif alignment == MenuQuadrants.BottomRight  then start = { x = quad_width * 2, y = quad_height * 2 }
    end
end

function Menu:set_background(x, y, w, h)
    background = { x = x, y = y, w = w, h = h }
end

function Menu:add_item(item)
	item.name = love.graphics.newText(titleFont, item.name)

	if self._width < item.name:getWidth() then
		self._width = item.name:getWidth()
	end

	self._height = self._height + item.name:getHeight()

	self._width_offset  = (screen_width/3) - self._width
	self._height_offset = (screen_height/3) - self._height

	table.insert(self._items, item)
end

function Menu:draw(x, y)
	-- Background
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", background.x + 1, background.y, background.w - 2, background.h - 1)

	love.graphics.setColor(0, 0, 0, 0.75)
	love.graphics.rectangle("fill", background.x, background.y, background.w, background.h)

	for i, item in ipairs(self._items) do
		love.graphics.setColor(1, 1, 1, self._selected == i and 1 or 0.5)

		local _x = start.x + (self._width_offset/ 2)
		local _y = start.y + item.name:getHeight() * (i - 1)

		if align ~= 0 then _x = _x + (self._width - item.name:getWidth()) / align end

		love.graphics.draw(item.name, _x + self._offset.x, _y + self._offset.y)
	end

	-- Reset to avoid alpha values outside of menu
	love.graphics.setColor(1, 1, 1)
end

function Menu:input(key)
	if #self._items > 1 then
		if key == InputMap.up then
			self._move_sfx:play()
			if self._selected > 1 then
				self._selected = self._selected - 1
			else
				self._selected = #self._items
			end
		elseif key == InputMap.down then
			self._move_sfx:play()
			if self._selected < #self._items then
				self._selected = self._selected + 1
			else
				self._selected = 1
			end
		end
	end

	if key == InputMap.a then
		if self._items[self._selected].action then
			if self._selected == #self._items then
				self._decline_sfx:play()
			else
				self._accept_sfx:play()
			end
			self._items[self._selected]:action()
		end
	end
end
