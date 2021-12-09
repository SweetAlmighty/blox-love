local Utils = require "src/utils/utils"
local Object = require "src/lib/classic"
local Resources = require "src/utils/resources"

local Color = Object:extend()

function Color:split() return self.r, self.g, self.b end
function Color:new(r, g, b) self.r, self.g, self.b = r, g, b end
function Color.__tostring(c) return "Color(" .. c.r .. ", " .. c.g.. ", " .. c.b.. ")" end

Color.colors = {}
local load = Resources.load_data("colors")
Utils.for_each(load, function(i, v)
    Color.colors[#Color.colors + 1] = Color(v.r / 255, v.g / 255, v.b / 255)
end)

return Color
