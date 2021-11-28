local Object = require "src/lib/classic"
local Color = require "src/utils/color"
local Resources = require "src/utils/resources"

local moonshine = require "src/lib/moonshine"
local box_blur = moonshine(moonshine.effects.boxblur)
box_blur.boxblur.radius = 5

local start = 0
local delta = 0
local rotate = 0
local offset = -1
local blocks = {}
local _color = nil
local color_index = 1
local rnd = math.random
local lg = love.graphics
local image = Resources.load_image('block')--lg.newImage("block.png")
local spriteBatch = lg.newSpriteBatch(image)
local imgWidth, imgHeight = image:getWidth(), image:getHeight()
local windowWidth, windowHeight = lg.getWidth(), lg.getHeight()

local iw, ih = (imgWidth / 2), (imgHeight / 2)

local MenuBackground = Object:extend()

function MenuBackground:new()
	--self._image = Resources.load_image('block')
	--self._sprite_batch = lg.newSpriteBatch(image)

    for i = 1, 25 do
        _color = Color.colors[color_index]
        color_index = color_index == #Color.colors and 1 or color_index + 1
        blocks[#blocks + 1] = {x = rnd(iw, (windowWidth + imgWidth) - iw), y = rnd(ih, windowHeight - ih), color = _color}
    end
end

function MenuBackground:draw()
	box_blur(function()
	    spriteBatch:clear()

	    for i, v in ipairs(blocks) do
	        spriteBatch:setColor(v.color.r, v.color.g, v.color.b)
	        spriteBatch:add(v.x, v.y, rotate, 1, 1, imgWidth / 2, imgHeight / 2)
	    end

	    love.graphics.draw(spriteBatch)
    end)
end

function MenuBackground:update(dt)
    delta = dt * offset
    rotate = rotate + delta
    start = math.min(1, math.max(-1, start + delta))

    for i, v in ipairs(blocks) do
        if v.x < -imgWidth then
            v.x = windowWidth + imgWidth
            v.y = rnd(ih, windowHeight - ih)
        elseif v.x > windowWidth + imgWidth then
            v.x = -imgWidth
            v.y = rnd(ih, windowHeight - ih)
        else
            v.x = v.x + start
        end
    end
end

function MenuBackground:mousemoved(x, y, dx, dy, istouch) offset = (x - (windowWidth / 2)) / (windowWidth / 2) end

return MenuBackground
