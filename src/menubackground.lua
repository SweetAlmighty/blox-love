local Color = require "src/utils/color"
local Utils = require "src/utils/utils"
local Object = require "src/lib/classic"
local Updater = require "src/utils/updater"
local moonshine = require "src/lib/moonshine"
local Resources = require "src/utils/resources"

local MenuBackground = Object:extend()

local random = love.math.random
local draw = love.graphics.draw
local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()

local function rand_y(self) return random(-self._image_size.h, windowHeight + self._image_size.h) end
local function clamp_scalar(value) return Utils.clamp((value - (windowWidth / 2)) / (windowWidth / 2), -1, 1) end
local function rand_pos(self) return random(-self._image_size.w, windowWidth + self._image_size.w), rand_y(self) end

local function initialize_blocks(self)
    local color = nil
    local x, y = 0, 0
    for i = 1, 350 do
        x, y = rand_pos(self)
        color, self._color_index = Color.sequential_color(self._color_index)
        self._blocks[#self._blocks + 1] = { x = x, y = y, color = color }
    end
end

local function draw_blocks(self)
    self._sprite_batch:clear()

    for i, v in ipairs(self._blocks) do
        self._sprite_batch:setColor(v.color.r, v.color.g, v.color.b)
        self._sprite_batch:add(v.x, v.y, self._rotate, self._img_scale, self._img_scale, self._image_size.hw, self._image_size.hh)
    end

    draw(self._sprite_batch)
end

local function update_and_clamp_blocks(self)
    self._rotate = self._rotate + 0.01 * self._scalar
    self._offset = Utils.clamp(self._offset + (0.1 * self._scalar), -self._img_scale, self._img_scale)

    for i, v in ipairs(self._blocks) do
        v.x = Utils.wrap(v.x + self._offset, -self._image_size.w, windowWidth + self._image_size.w)
        if v.x < -self._image_size.w or v.x > windowWidth + self._image_size.w then
            v.y = rand_y(self)
        end
    end
end

function MenuBackground:new()
    self._delta = 0
    self._rotate = 0
    self._offset = 0
    self._blocks = {}
    self._scalar = -1
    self._img_scale = 5
    self._color_index = 1
    self._horizontal_pos = 0
    self._accelerometer_scalar = 100
    self._image = Resources.load_image('block')
    self._draw_blocks = function() draw_blocks(self) end
    self._sprite_batch = love.graphics.newSpriteBatch(self._image)
    self._update_blocks = function() update_and_clamp_blocks(self) end
    self._joystick = love.joystick.getJoysticks()[love.joystick.getJoystickCount()]

    self._updater = Updater(60, self._update_blocks)

    self._image_size = {
        w = self._image:getWidth() * self._img_scale,
        h = self._image:getHeight() * self._img_scale,
        hw = self._image:getWidth() / 2,
        hh = self._image:getHeight() / 2
    }

    initialize_blocks(self)
end

function MenuBackground:update(dt)
    self._updater:update()

    if self._joystick then
        _, axis2 = self._joystick:getAxes()
        self._horizontal_pos = self._horizontal_pos + (axis2 * self._accelerometer_scalar)
        self._horizontal_pos = Utils.clamp(self._horizontal_pos, 0, windowWidth)
        self._scalar = clamp_scalar(self._horizontal_pos)
    end
end

function MenuBackground:unpause() self._updater:reset() end
function MenuBackground:draw() Utils.blur(self._draw_blocks) end
function MenuBackground:mouse_moved(x, y, dx, dy, istouch) if not self._joystick then self._scalar = clamp_scalar(x) end end

return MenuBackground
