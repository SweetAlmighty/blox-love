require "src/ui/ui"

SettingsUI = Object:extend()

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

function SettingsUI:new(onReset, onSkip)
    local function onHomeRelease()
        UI.createModal("Return Home?", "modal", function()
            self._panel:setVisible(false)
            state_machine:clear()
        end)
    end

    local function onResetRelease()
        UI.createModal("Reset blocks?", "modal", function()
            self._panel:setVisible(false)
            if Gameplay.onReset ~= nil then Gameplay.onReset() end -- hack :(
            state_machine:pop()
        end)
    end

    local function onSkipRelease()
        UI.createModal("Skip?", "modal", function()
            self._panel:setVisible(false)
            if Gameplay.onSkip ~= nil then Gameplay.onSkip() end -- hack :(
            state_machine:pop()
        end)
    end

    self._panel = UI.createPanel("SETTINGS", {
        x = (love.graphics.getWidth()/2) - 200,
        y = (love.graphics.getHeight()/2) - 200,
        w = 400,
        h = 400
    }, "grid", 4, 3)

    self._panel:setColspan(1, 1, 3)
                :setColspan(2, 1, 2)
                :setColspan(3, 1, 2)

    self._panel:add(
        UI.createSlider(Sound.musicVolume, updateMusicSlider),
        UI.createButton("", musicIcon, updateMusicMute),
        UI.createSlider(Sound.SfxVolume, updateSfxSlider),
        UI.createButton("", sfxIcon, updateSfxMute),
        UI.createButton("", homeIcon, onHomeRelease),
        UI.createButton("", returnIcon, onResetRelease),
        UI.createButton("", nextIcon, onSkipRelease)
    ):setOpaque(true):setVisible(false)
end

function SettingsUI:setVisible(visible)
    self._panel:setVisible(visible)
end
