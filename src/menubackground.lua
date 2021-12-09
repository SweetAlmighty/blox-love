local Color = require "src/utils/color"
local Utils = require "src/utils/utils"
local Object = require "src/lib/classic"
local Updater = require "src/utils/updater"
local moonshine = require "src/lib/moonshine"
local Resources = require "src/utils/resources"

local MenuBackground = Object:extend()

local color_index = 1
local random = love.math.random
local draw = love.graphics.draw
local getWidth = love.graphics.getWidth
local getHeight = love.graphics.getHeight
local newSpriteBatch = love.graphics.newSpriteBatch
local windowWidth, windowHeight = getWidth(), getHeight()

local function rand_y(self) return random(-self._image_size.h, windowHeight + self._image_size.h) end
local function rand_pos(self) return random(-self._image_size.w, windowWidth + self._image_size.w), rand_y(self) end

local function initialize_blocks(self)
    self._blocks = {}
    local color = nil
    local x, y = 0, 0
    for i = 1, 350 do
        x, y = rand_pos(self)
        color = Color.colors[color_index]
        self._blocks[#self._blocks + 1] = { x = x, y = y, color = color }
        color_index = color_index == #Color.colors and 1 or color_index + 1
    end
end

local function draw_blocks(self)
    self._sprite_batch:clear()

    for i, v in ipairs(self._blocks) do
        self._sprite_batch:setColor(v.color.r, v.color.g, v.color.b)
        self._sprite_batch:add(v.x, v.y, self._rotate, self._scale, self._scale, self._image_size.hw, self._image_size.hh)
    end

    draw(self._sprite_batch)
end

local function update_and_clamp_blocks(self)
    self._delta = 0.01 * self._offset
    self._rotate = self._rotate + self._delta
    self._start = Utils.clamp(self._start + self._delta, -self._scale, self._scale)

    for i, v in ipairs(self._blocks) do
        v.x = Utils.wrap(v.x + self._start, -self._image_size.w, windowWidth + self._image_size.w)
        if v.x < -self._image_size.w or v.x > windowWidth + self._image_size.w then
            v.y = rand_y(self)
        end
    end
end

function MenuBackground:new()
    self._start = 0
    self._delta = 0
    self._scale = 5
    self._rotate = 0
    self._offset = -1
    self._image = Resources.load_image('block')
    self._sprite_batch = newSpriteBatch(self._image)
    self._draw_blocks = function() draw_blocks(self) end

    self._image_size = {
        w = self._image:getWidth() * self._scale, h = self._image:getHeight() * self._scale,
        hw = self._image:getWidth() / 2, hh = self._image:getHeight() / 2
    }

    self._updater = Updater(60, function() update_and_clamp_blocks(self) end)

    initialize_blocks(self)
end

function MenuBackground:unpause() self._updater:reset() end
function MenuBackground:update(dt) self._updater:update() end
function MenuBackground:draw() Utils.blur(self._draw_blocks) end
function MenuBackground:mouse_moved(x, y, dx, dy, istouch) self._offset = (x - (windowWidth / 2)) / (windowWidth / 2) end

return MenuBackground
