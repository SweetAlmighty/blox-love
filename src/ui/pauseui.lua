local center = {
    x = (1280 / 2) - 150,
    y = (720 / 2) - 150
}

PauseUI = Object:extend()

local function createMusicButton(self)
    local btn = gooi.newButton({text = ""})
    :setIcon("data/images/musicOn.png")
    btn:onRelease(function()
        self._musicMute = not self._musicMute
        btn:setIcon("data/images/" .. (self._musicMute and "musicOff" or "musicOn") .. ".png")
    end)
    return btn
end

local function createSFXButton(self)
    local btn = gooi.newButton({text = ""})
    :setIcon("data/images/audioOn.png")
    btn:onRelease(function()
        self._sfxMute = not self._sfxMute
        btn:setIcon("data/images/" .. (self._sfxMute and "audioOff" or "audioOn") .. ".png")
    end)
    return btn
end

function PauseUI:new(onReset, onSkip)
    self._sfxMute = false
    self._musicMute = false

    self._grid = gooi.newPanel({x = center.x, y = center.y, w = 300, h = 300, layout = "grid 4x3"})
    self._grid
    :setColspan(1, 1, 3)
    :setColspan(2, 1, 2)
    :setColspan(3, 1, 2)
    :add(
        gooi.newLabel({text = "Pause"})
        :center(),
        gooi.newSlider({value = 0.2})
        :setOnValueUpdated(function(v) print(v) end),
        createSFXButton(self),
        gooi.newSlider({value = 0.4})
        :setOnValueUpdated(function(v) print(v) end),
        createMusicButton(self),
        gooi.newButton({text = ""})
        :setIcon("data/images/home.png")
        :onRelease(function()
            gooi.confirm({
                text = "Return to Home?",
                ok = function()
                    self:setVisible(false)
                    state_machine:pop()
                end
            })
        end),
        gooi.newButton({text = ""})
        :setIcon("data/images/return.png")
        :onRelease(function()
            gooi.confirm({
                text = "Reset the board?",
                ok = function()
                    self:setVisible(false)
                    onReset()
                end
            })
        end),
        gooi.newButton({text = ""})
        :setIcon("data/images/next.png")
        :onRelease(function()
            gooi.confirm({
                text = "Skip this puzzle?",
                ok = function()
                    self:setVisible(false)
                    onSkip()
                end
            })
        end))
        :setOpaque(true)
        :setVisible(false)
end

function PauseUI:draw()
    love.graphics.setColor(0.25, 0.25, 0.25, 0.5)
    love.graphics.rectangle("fill", 0,0, 1280,720)
    love.graphics.setColor(1, 1, 1)
end

function PauseUI:setVisible(visible)
    self._grid:setVisible(visible)
end
