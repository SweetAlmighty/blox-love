local Object = require "src/lib/classic"

local GameUI = Object:extend()

local function set_icon(self)
    self._settings:setIcon("data/images/" .. (self._clicked and "cross" or "gear") .. ".png")
end

function GameUI:new(on_settings_clicked)
    self._clicked = false
    self._settings = gooi.newButton({text = "", w = 50, h = 50})
                        :setIcon("data/images/gear.png")
                        :onRelease(function()
                            self._clicked = not self._clicked
                            set_icon(self)
                            on_settings_clicked()
                        end)

    self._layout = gooi.newPanel({
        x = 0,
        y = 0,
        layout = "game",
        w = love.graphics.getWidth(),
        h = love.graphics.getHeight()
    })

    self._layout:add(self._settings, "t-r")
                :setVisible(false)
end

function GameUI:reset_clicked()
    self._clicked = false
    set_icon(self)
end

function GameUI:set_visible(visible)
    self._layout:setVisible(visible)
end

return GameUI
