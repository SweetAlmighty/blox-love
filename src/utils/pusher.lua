local Push = require "src/lib/push"

local Pusher = {}

local thing = { fullscreen = false, resizable = false, ... }

local _x = 0
local _y = 0

local gameWidth = 1280
local gameHeight = 720

love.mouse.getX = function() return _x end
love.mouse.getY = function() return _y end

love.graphics.getWidth = function() return gameWidth end
love.graphics.getHeight = function() return gameHeight end

local screenWidth, screenHeight = love.window.getDesktopDimensions()
Push:setupScreen(gameWidth, gameHeight, screenWidth, screenHeight, thing)

function Pusher.toGame(x, y)
	local dx, dy = _x, _y

    _x, _y = Push:toGame(x, y)

    _x = _x == nil and x or _x
    _y = _y == nil and y or _y

    dx = _x - dx
    dy = _y - dy

    return _x, _y, dx, dy
end

function Pusher.start() Push:start() end
function Pusher.finish() Push:finish() end
function Pusher.resize(w, h) Push:resize(w, h) end

return Pusher