Color = Object:extend()

Color.colors = {}

local load = Resources.LoadData("colors")

function Color:new(r, g, b)
    self.r = r
    self.g = g
    self.b = b
end

foreach(load, function(i, v)
    Color.colors[#Color.colors + 1] = Color(v.r / 255, v.g / 255, v.b / 255)
end)

function Color.__tostring(c)
    return "Color(" .. c.r .. ", " .. c.g.. ", " .. c.b.. ")"
end
