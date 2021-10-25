Color = Object:extend()

local load = Resources.LoadData("colors")

Color.colors = {}

for i = 1, #load do
    Color.colors[#Color.colors + 1] = Color(load[i].r / 255, load[i].g / 255, load[i].b / 255)
end

function Color:new(r, g, b)
    self.r = r
    self.g = g
    self.b = b
end
