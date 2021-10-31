require "src/ui/ui"

PauseUI = Object:extend()

local function homeIcon() return "home" end
local function returnIcon() return "return" end
local function nextIcon() return "next" end

local function musicIcon()
    return Sound.musicMute and "musicOff" or "musicOn"
end

local function sfxIcon()
    return Sound.sfxMute and "audioOff" or "audioOn"
end

local function updateMusicSlider(v)
    Sound.musicVolume = v
    Resources.SetAudioVolume()
end

local function updateSfxSlider(v)
    Sound.sfxVolume = v
    Resources.SetAudioVolume()
end

local function updateMusicMute()
    Sound.musicMute = not Sound.musicMute
    Resources.SetAudioVolume()
end

local function updateSfxMute()
    Sound.sfxMute = not Sound.sfxMute
    Resources.SetAudioVolume()
end

function PauseUI:new(onReset, onSkip)
    local function onHomeRelease()
        UI.createModal("Return Home?", function()
            self._layout:setVisible(false)
            state_machine:clear()
        end)
    end

    local function onResetRelease()
        UI.createModal("Reset blocks?", function()
            self._layout:setVisible(false)
            onReset()
        end)
    end

    local function onSkipRelease()
        UI.createModal("Skip?", function()
            self._layout:setVisible(false)
            onSkip()
        end)
    end

    self._layout = UI.createPanel("PAUSE", {
        x = (love.graphics.getWidth()/2) - 200,
        y = (love.graphics.getHeight()/2) - 200,
        w = 400,
        h = 400
    }, "grid", 4, 3)

    self._layout:setColspan(1, 1, 3)
                :setColspan(2, 1, 2)
                :setColspan(3, 1, 2)

    self._layout:add(
        UI.createSlider(Sound.musicVolume, updateMusicSlider),
        UI.createButton("", musicIcon, updateMusicMute),
        UI.createSlider(Sound.SfxVolume, updateSfxSlider),
        UI.createButton("", sfxIcon, updateSfxMute),
        UI.createButton("", homeIcon, onHomeRelease),
        UI.createButton("", returnIcon, onResetRelease),
        UI.createButton("", nextIcon, onSkipRelease)
    ):setOpaque(true):setVisible(false)
end

function PauseUI:setVisible(visible)
    self._layout:setVisible(visible)
end
