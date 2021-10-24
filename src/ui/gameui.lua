GameUI = Object:extend()

local function SetIcon(self, clicked)
    self._clicked = clicked
    self._settings:setIcon("data/images/" .. (self._clicked and "cross" or "gear") .. ".png")
end

function GameUI:new(onSettingsClicked)
    self._clicked = false
    self._settings = gooi.newButton({text = "", w = 50, h = 50})
    :setIcon("data/images/gear.png")
    :onRelease(function()
        onSettingsClicked()
        SetIcon(self, not self._clicked)
    end)

    self._layout = gooi.newPanel({x = 0, y = 0, w = 1280, h = 720, layout = "game"})
    self._layout:add(self._settings, "t-r")
    :setVisible(false)
end

function GameUI:resetClicked()
    SetIcon(self, false)
end

function GameUI:setVisible(visible)
    self._layout:setVisible(visible)
end
