local Color = require "src/utils/color"
local Utils = require "src/utils/utils"
local Object = require "src/lib/classic"
local moonshine = require "src/lib/moonshine"
local Resources = require "src/utils/resources"

local MenuBackground = Object:extend()

local color_index = 1
local rnd = math.random
local lg = love.graphics
local updatesPerSec = 60
local nextUpdate = Utils.now()
local currentTime = Utils.now()
local skipTicks = 1000/updatesPerSec
local windowWidth, windowHeight = lg.getWidth(), lg.getHeight()

function MenuBackground:new()
    self._start = 0
    self._delta = 0
    self._rotate = 0
    self._offset = -1
    self._blocks = {}
    self._image = Resources.load_image('block')
    self._sprite_batch = lg.newSpriteBatch(self._image)
    self._imgSize = {
        w = self._image:getWidth(), h = self._image:getHeight(),
        hw = self._image:getWidth() / 2, hh = self._image:getHeight() / 2
    }

    self._box_blur = moonshine(moonshine.effects.boxblur)
    self._box_blur.boxblur.radius = 5

    local color = nil
    for i = 1, 25 do
        color = Color.colors[color_index]
        color_index = color_index == #Color.colors and 1 or color_index + 1
        self._blocks[#self._blocks + 1] = {
            color = color,
            y = rnd(self._imgSize.hh, windowHeight - self._imgSize.hh),
            x = rnd(self._imgSize.hw, (windowWidth + self._imgSize.w) - self._imgSize.hw)
        }
    end
end

function MenuBackground:draw()
    self._box_blur(function()
        self._sprite_batch:clear()

        for i, v in ipairs(self._blocks) do
            self._sprite_batch:setColor(v.color.r, v.color.g, v.color.b)
            self._sprite_batch:add(v.x, v.y, self._rotate, 1, 1, self._imgSize.hw, self._imgSize.hh)
        end

        lg.draw(self._sprite_batch)
    end)
end

function MenuBackground:update(dt)
    currentTime = Utils.now()
    if nextUpdate < currentTime then
        self._delta = 0.01 * self._offset
        self._rotate = self._rotate + self._delta
        self._start = math.min(1, math.max(-1, self._start + self._delta))

        for i, v in ipairs(self._blocks) do
            if v.x < -self._imgSize.w then
                v.x = windowWidth + self._imgSize.w
                v.y = rnd(self._imgSize.hh, windowHeight - self._imgSize.hh)
            elseif v.x > windowWidth + self._imgSize.w then
                v.x = -self._imgSize.w
                v.y = rnd(self._imgSize.hh, windowHeight - self._imgSize.hh)
            else
                v.x = v.x + self._start
            end
        end
        nextUpdate = nextUpdate + skipTicks
    end
end

function MenuBackground:mouse_moved(x, y, dx, dy, istouch) self._offset = (x - (windowWidth / 2)) / (windowWidth / 2) end

return MenuBackground
