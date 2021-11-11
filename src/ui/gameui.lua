GameUI = Object:extend()

local function setIcon(self)
    self._settings:setIcon("data/images/" .. (self._clicked and "cross" or "gear") .. ".png")
end

function GameUI:new(onSettingsClicked)
    self._clicked = false
    self._settings = gooi.newButton({text = "", w = 50, h = 50})
                        :setIcon("data/images/gear.png")
                        :onRelease(function()
                            self._clicked = not self._clicked
                            setIcon(self)
                            onSettingsClicked()
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

function GameUI:resetClicked()
    self._clicked = false
    setIcon(self)
end

function GameUI:setVisible(visible)
    self._layout:setVisible(visible)
end
