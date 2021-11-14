Color = Object:extend()

Color.colors = {}

local load = Resources.load_data("colors")

function Color:new(r, g, b)
    self.r = r
    self.g = g
    self.b = b
end

for_each(load, function(i, v)
    Color.colors[#Color.colors + 1] = Color(v.r / 255, v.g / 255, v.b / 255)
end)

function Color:split() return self.r, self.g, self.b end

function Color.__tostring(c) return "Color(" .. c.r .. ", " .. c.g.. ", " .. c.b.. ")" end
