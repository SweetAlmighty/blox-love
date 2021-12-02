local Color = require "src/utils/color"
local Utils = require "src/utils/utils"
local Object = require "src/lib/classic"
local Updater = require "src/utils/updater"
local moonshine = require "src/lib/moonshine"
local Resources = require "src/utils/resources"

local MenuBackground = Object:extend()

local color_index = 1
local rnd = math.random
local lg = love.graphics
local windowWidth, windowHeight = lg.getWidth(), lg.getHeight()

local function draw_blocks(self)
    self._sprite_batch:clear()
    for _, v in ipairs(self._blocks) do
        for _, w in ipairs(v) do
            self._sprite_batch:setColor(w.color.r, w.color.g, w.color.b)
            self._sprite_batch:add(w.x, w.y, self._rotate, 1, 1, self._img_size.hw, self._img_size.hh)
        end
    end
    lg.draw(self._sprite_batch)
end

local function update_and_clamp_blocks(self)
    self._delta = 0.01 * self._offset
    self._rotate = self._rotate + self._delta
    self._start = math.min(1, math.max(-1, self._start + self._delta))

    for _, v in ipairs(self._blocks) do
        for _, w in ipairs(v) do
            if w.x < -self._img_size.w then
                w.x = self._width
            elseif w.x > self._width then
                w.x = -self._img_size.w
            else
                w.x = w.x + self._start
            end
        end
    end
end

local function create_blocks(self)
    local color = nil

    local w = math.floor((windowWidth / self._img_size.w) / 2) + 2
    local h = math.floor((windowHeight / self._img_size.h) / 2) + 1

    for i = 1, h do
        local row = {}
        for j = 1, w do
            color = Color.colors[color_index]
            color_index = (color_index % #Color.colors) + 1

            row[#row + 1] = {
                color = color,
                x = (self._img_size.w * (j - 1) * 2),
                y = (self._img_size.h * (i - 1) * 2) + self._img_size.hh
            }
        end
        self._blocks[#self._blocks + 1] = row
    end

    self._width = self._blocks[#self._blocks][w].x + self._img_size.w
end

function MenuBackground:new()
    self._start = 0
    self._delta = 0
    self._rotate = 0
    self._offset = -1
    self._blocks = {}
    self._image = Resources.load_image('block')
    self._sprite_batch = lg.newSpriteBatch(self._image)
    self._draw_blocks = function() draw_blocks(self) end
    self._update_blocks = function() update_and_clamp_blocks(self) end
    self._img_size = {
        w = self._image:getWidth(), h = self._image:getHeight(),
        hw = self._image:getWidth() / 2, hh = self._image:getHeight() / 2
    }

    self._updater = Updater(60, self._update_blocks)

    self._box_blur = moonshine(moonshine.effects.boxblur)
    self._box_blur.boxblur.radius = 5

    create_blocks(self)
end

function MenuBackground:update(dt) self._updater:update() end
function MenuBackground:draw() self._box_blur(self._draw_blocks) end
function MenuBackground:mouse_moved(x, y, dx, dy, istouch) self._offset = (x - (windowWidth / 2)) / (windowWidth / 2) end

return MenuBackground
