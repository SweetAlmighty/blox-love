local UI = require "src/ui/ui"
local Sound = require "src/utils/sound"
local Object = require "src/lib/classic"
local Resources = require "src/utils/resources"
local Gameplay = require "src/states/gameplay"

local SettingsUI = Object:extend()

local function home_icon() return "home" end
local function next_icon() return "next" end
local function return_icon() return "return" end
local function sfx_icon() return Sound.sfxMute and "audioOff" or "audioOn" end
local function music_icon() return Sound.musicMute and "musicOff" or "musicOn" end

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
        UI.create_modal("Return Home?", "modal", function()
            self._panel:setVisible(false)
            state_machine:clear()
        end)
    end

    local function on_reset_release()
        UI.create_modal("Reset?", "modal", function()
            self._panel:setVisible(false)
            if Gameplay.on_reset ~= nil then Gameplay.on_reset() end -- hack :(
            state_machine:pop()
        end)
    end

    local function on_skip_release()
        UI.create_modal("Skip?", "modal", function()
            self._panel:setVisible(false)
            if Gameplay.on_regen ~= nil then Gameplay.on_regen() end -- hack :(
            state_machine:pop()
        end)
    end

    self._panel = UI.create_panel("SETTINGS", {
        x = (love.graphics.getWidth()/3),
        y = (love.graphics.getHeight()/4),
        w = (love.graphics.getWidth()/3),
        h = (love.graphics.getHeight()/2)
    }, "grid", 4, 3)

    self._panel :setColspan(2, 1, 2)
                :setColspan(3, 1, 2)

    self._panel:add(
        UI.create_slider(Sound.musicVolume, update_music_slider),
        UI.create_button("", music_icon, update_music_mute),
        UI.create_slider(Sound.sfxVolume, update_sfx_slider),
        UI.create_button("", sfx_icon, update_sfx_mute),
        UI.create_button("", home_icon, on_home_release),
        UI.create_button("", return_icon, on_reset_release),
        UI.create_button("", next_icon, on_skip_release)
    ):setOpaque(true):setVisible(false)
end

function SettingsUI:set_visible(visible)
    self._panel:setVisible(visible)
end

return SettingsUI
