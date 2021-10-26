local center = {
    x = (1280 / 2) - 150,
    y = (720 / 2) - 150
}

PauseUI = Object:extend()

local function musicIcon()
    return "data/images/" .. (Sound.musicMute and "musicOff" or "musicOn") .. ".png"
end

local function sfxIcon()
    return "data/images/" .. (Sound.sfxMute and "audioOff" or "audioOn") .. ".png"
end

local function createMusicButton(self)
    local btn = gooi.newButton({text = ""}):setIcon(musicIcon())
    btn:onRelease(function()
        Sound.musicMute = not Sound.musicMute
        Resources.SetAudioVolume()
        self._switch2:play()
        btn:setIcon(musicIcon())
    end)
    return btn
end

local function createSFXButton(self)
    local btn = gooi.newButton({text = ""}):setIcon(sfxIcon())
    btn:onRelease(function()
        Sound.sfxMute = not Sound.sfxMute
        Resources.SetAudioVolume()
        self._switch2:play()
        btn:setIcon(sfxIcon())
    end)
    return btn
end

function PauseUI:new(onReset, onSkip)
    self._switch2 = Resources.LoadSFX('Switch sounds 2')
    self._switch13 = Resources.LoadSFX('Switch sounds 13')

    self._grid = gooi.newPanel({x = center.x, y = center.y, w = 300, h = 300, layout = "grid 4x3"})
    self._grid
    :setColspan(1, 1, 3)
    :setColspan(2, 1, 2)
    :setColspan(3, 1, 2)
    :add(
        gooi.newLabel({text = "Pause"})
        :center(),
        gooi.newSlider({value = Sound.musicVolume})
        :setOnValueUpdated(function(v)
            Sound.musicVolume = v
            Resources.SetAudioVolume()
        end),
        createMusicButton(self),
        gooi.newSlider({value = Sound.sfxVolume})
        :setOnValueUpdated(function(v)
            Sound.sfxVolume = v
            Resources.SetAudioVolume()
        end),
        createSFXButton(self),
        gooi.newButton({text = ""})
        :setIcon("data/images/home.png")
        :onRelease(function()
            self._switch2:play()
            gooi.confirm({
                okText = 'Y',
                cancelText = 'N',
                text = "Return Home?",
                ok = function()
                    self._switch2:play()
                    self:setVisible(false)
                    state_machine:pop()
                end,
                cancel = function()
                    self._switch2:play()
                end
            })
            Resources.Save()
        end),
        gooi.newButton({text = ""})
        :setIcon("data/images/return.png")
        :onRelease(function()
            self._switch2:play()
            gooi.confirm({
                okText = 'Y',
                cancelText = 'N',
                text = "Reset blocks?",
                ok = function()
                    self._switch2:play()
                    self:setVisible(false)
                    onReset()
                end,
                cancel = function()
                    self._switch2:play()
                end
            })
            Resources.Save()
        end),
        gooi.newButton({text = ""})
        :setIcon("data/images/next.png")
        :onRelease(function()
            self._switch2:play()
            gooi.confirm({
                okText = 'Y',
                cancelText = 'N',
                text = "Skip?",
                ok = function()
                    self._switch13:play()
                    self:setVisible(false)
                    onSkip()
                end,
                cancel = function()
                    self._switch2:play()
                end
            })
            Resources.Save()
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
