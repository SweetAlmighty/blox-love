local UI = require "src/ui/ui"
local Sound = require "src/utils/sound"
local Object = require "src/lib/classic"
local Resources = require "src/utils/resources"
local Gameplay = require "src/states/gameplay"

local SettingsUI = Object:extend()

local getWidth = love.graphics.getWidth
local getHeight = love.graphics.getHeight

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

local function on_home_release(self)
    UI.create_modal("Return Home?", "modal", function()
        self._panel:setVisible(false)
        state_machine:clear()
    end)
end

local function on_reset_release(self)
    UI.create_modal("Reset?", "modal", function()
        self._panel:setVisible(false)
        if Gameplay.on_reset ~= nil then Gameplay.on_reset() end -- hack :(
        state_machine:pop()
    end)
end

local function on_skip_release(self)
    UI.create_modal("Skip?", "modal", function()
        self._panel:setVisible(false)
        if Gameplay.on_regen ~= nil then Gameplay.on_regen() end -- hack :(
        state_machine:pop()
    end)
end

function SettingsUI:new(board_present)
    self._on_skip_release = function() on_skip_release(self) end
    self._on_home_release = function() on_home_release(self) end
    self._on_reset_release = function() on_reset_release(self) end

    self._panel = UI.create_panel("SETTINGS", {
        x = getWidth()/3, y = getHeight()/4,
        w = getWidth()/3, h = getHeight()/2
    }, "grid", 4, 3)

    self._panel :setColspan(2, 1, 2)
                :setColspan(3, 1, 2)

    if board_present then
        self._panel:add(
            UI.create_slider(Sound.musicVolume, update_music_slider),
            UI.create_button("", music_icon, update_music_mute),
            UI.create_slider(Sound.sfxVolume, update_sfx_slider),
            UI.create_button("", sfx_icon, update_sfx_mute)
        ):setOpaque(true):setVisible(false)
    else
        self._panel:add(
            UI.create_slider(Sound.musicVolume, update_music_slider),
            UI.create_button("", music_icon, update_music_mute),
            UI.create_slider(Sound.sfxVolume, update_sfx_slider),
            UI.create_button("", sfx_icon, update_sfx_mute),
            UI.create_button("", home_icon, self._on_home_release),
            UI.create_button("", return_icon, self._on_reset_release),
            UI.create_button("", next_icon, self._on_skip_release)
        ):setOpaque(true):setVisible(false)
    end
end

function SettingsUI:set_visible(visible) self._panel:setVisible(visible) end

return SettingsUI
