require "src/ui/ui"

SettingsUI = Object:extend()

local function home_icon() return "home" end
local function return_icon() return "return" end
local function next_icon() return "next" end

local function music_icon()
    return Sound.musicMute and "musicOff" or "musicOn"
end

local function sfx_icon()
    return Sound.sfxMute and "audioOff" or "audioOn"
end

local function update_music_slider(v)
    Sound.musicVolume = v
    Resources.set_audio_volume()
end

local function update_sfx_slider(v)
    Sound.sfxVolume = v
    Resources.set_audio_volume()
end

local function update_music_mute()
    Sound.musicMute = not Sound.musicMute
    Resources.set_audio_volume()
end

local function update_sfx_mute()
    Sound.sfxMute = not Sound.sfxMute
    Resources.set_audio_volume()
end

function SettingsUI:new()
    local function on_home_release()
        UI.createModal("Return Home?", "modal", function()
            self._panel:setVisible(false)
            state_machine:clear()
        end)
    end

    local function on_reset_release()
        UI.createModal("Reset?", "modal", function()
            self._panel:setVisible(false)
            if Gameplay.on_reset ~= nil then Gameplay.on_reset() end -- hack :(
            state_machine:pop()
        end)
    end

    local function on_skip_release()
        UI.createModal("Skip?", "modal", function()
            self._panel:setVisible(false)
            if Gameplay.on_regen ~= nil then Gameplay.on_regen() end -- hack :(
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
        UI.createSlider(Sound.musicVolume, update_music_slider),
        UI.createButton("", music_icon, update_music_mute),
        UI.createSlider(Sound.sfxVolume, update_sfx_slider),
        UI.createButton("", sfx_icon, update_sfx_mute),
        UI.createButton("", home_icon, on_home_release),
        UI.createButton("", return_icon, on_reset_release),
        UI.createButton("", next_icon, on_skip_release)
    ):setOpaque(true):setVisible(false)
end

function SettingsUI:set_visible(visible)
    self._panel:setVisible(visible)
end
