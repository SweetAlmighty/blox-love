local Sound = require "src/misc/sound"
local State = require "src/states/state"
local Resources = require "src/utils/resources"

local getWidth = love.graphics.getWidth
local getHeight = love.graphics.getHeight
local buttonPress = Resources.load_sfx('Go forward sounds 1')

local UI = {}
local settings = nil
local clicked = false

local style = {
    bgColor = { 0.5, 0.5, 1 },
    font = Resources.load_font("Uni Sans Heavy", 30),
}

gooi.setStyle(style)

local function update_music_slider(v)
    Sound.musicVolume = v
    Resources.set_audio_volume()
end

local function update_sfx_slider(v)
    Sound.sfxVolume = v
    Resources.set_audio_volume()
end

local function update_music_mute()
	buttonPress:play()
    Sound.musicMute = not Sound.musicMute
    Resources.set_audio_volume()
end

local function update_sfx_mute()
	buttonPress:play()
    Sound.sfxMute = not Sound.sfxMute
    Resources.set_audio_volume()
end

local function cross() return "cross" end
local function home_icon() return "home" end
local function next_icon() return "next" end
local function return_icon() return "return" end
local function checkmark() return "checkmark" end
local function icon_path(name) return "data/images/" .. name .. ".png" end
local function sfx_icon() return Sound.sfxMute and "audioOff" or "audioOn" end
local function music_icon() return Sound.musicMute and "musicOff" or "musicOn" end

local function create_button(text, icon, onRelease)
	local btn = gooi.newButton({text = text})

	local function updateIcon()
	    if icon then btn:setIcon(icon_path(icon())) end
	end

	btn:onRelease(function()
		onRelease()
		updateIcon()
	end)

    updateIcon()

    return btn
end

local function create_slider(value, onUpdate)
    return gooi.newSlider({value = value})
	            :setOnValueUpdated(onUpdate)
end

local function create_panel(title, info, type, width, height)
	info.layout = type .. " " .. width .. "x" .. height

	local panel = gooi.newPanel(info)
	panel:setColspan(1, 1, height)
	panel:add(gooi.newLabel({text = title}):center())
	
	return panel
end

local function create_modal(text, style, ok)
    gooi.panelDialog = create_panel("", {
	    x = getWidth()/2.67,
	    y = getHeight()/3,
	    w = getWidth()/4,
	    h = getHeight()/3
	}, "grid", 3, 3):setOpaque(true):warning()

	local function cancel()
		buttonPress:play()
		gooi.showingDialog = false
		gooi.removeComponent(gooi.panelDialog)
	end

	local function continue()
		cancel()
		if ok ~= nil then ok() end
	end

	gooi.lblDialog = gooi.newLabel({ text = text }):center()
	gooi.lblDialog.lblFlag = true
    gooi.panelDialog:add(gooi.lblDialog, "2,2")

	if style == "modal" then
    	gooi.yesButton = create_button("", checkmark, continue):warning()
      	gooi.yesButton.yesFlag = true
	    gooi.panelDialog:add(gooi.yesButton, "3,3")

    	gooi.noButton = create_button("", cross, cancel):warning()
      	gooi.noButton.noFlag = true
	    gooi.panelDialog:add(gooi.noButton, "3,1")
	else
		gooi.okButton = create_button("", checkmark, continue):warning()
		gooi.okButton.okFlag = true
	    gooi.panelDialog:add(gooi.okButton, "3,2")
	end

    gooi.showingDialog = true
end

local function set_icon()
	clicked = not clicked
    settings:setIcon(icon_path(clicked and "cross" or "gear"))
end

function UI.remove(comp)
	gooi.removeComponent(comp)
end

function UI.grid_complete_modal(clicked)
    create_modal("SUCCESS!", "alert", clicked)
end

function UI.main_menu()
	local function on_exit()
	    Resources.save()
	    love.event.quit()
	end

	local function on_play_released()
		buttonPress:play()
		state_machine:push(State.GameStates.Gameplay)
	end

	local function on_exit_released()
		buttonPress:play()
		create_modal("Exit Blox?", "modal", on_exit)
	end

    local panel = create_panel("BLOX", {x = 0, y = 0, w = getWidth(), h = getHeight()}, "grid", 5, 3)
    panel:add(create_button("PLAY", nil, on_play_released), "3,2")
    panel:add(create_button("EXIT", nil, on_exit_released), "4,2")

    return panel
end

function UI.main_settings()
    local panel = create_panel("SETTINGS", {
        x = getWidth()/3, y = getHeight()/4,
        w = getWidth()/3, h = getHeight()/2
    }, "grid", 3, 3)

    panel:setColspan(2, 1, 2)
    	 :setColspan(3, 1, 2)

    panel:add(
        create_slider(Sound.musicVolume, update_music_slider),
        create_button("", music_icon, update_music_mute),
        create_slider(Sound.sfxVolume, update_sfx_slider),
        create_button("", sfx_icon, update_sfx_mute)
    ):setOpaque(true):setVisible(false)

    return panel
end

function UI.game_ui(on_settings_clicked)
    settings = gooi.newButton({text = "", w = 50, h = 50})
                         :setIcon("data/images/gear.png")
                         :onRelease(function()
                             set_icon()
							 buttonPress:play()
                             on_settings_clicked(clicked)
                         end)

    local panel = gooi.newPanel({
        x = 0, y = 0,
        layout = "game",
        w = getWidth(),
        h = getHeight()
    })

    panel:add(settings, "t-r")

    return panel
end

function UI.game_settings(on_reset, on_regen)
    local panel = create_panel(" SETTINGS ", {
        x = getWidth()/3, y = getHeight()/4,
        w = getWidth()/3, h = getHeight()/2
    }, "grid", 4, 3)

    panel:setColspan(2, 1, 2)
    	 :setColspan(3, 1, 2)

   	local function on_press()
   		set_icon()
		buttonPress:play()
	    panel:setVisible(false)
   	end

	local function on_home_release()
		buttonPress:play()
	    create_modal("Main Menu?", "modal", function()
	    	on_press()
	        state_machine:pop()
	    end)
	end

	local function on_reset_release()
		buttonPress:play()
	    create_modal("Reset?", "modal", function()
	    	on_press()
	        if on_reset ~= nil then on_reset() end
	    end)
	end

	local function on_skip_release()
		buttonPress:play()
	    create_modal("Skip?", "modal", function()
	    	on_press()
	        if on_regen ~= nil then on_regen() end
	    end)
	end

    panel:add(
        create_slider(Sound.musicVolume, update_music_slider),
        create_button("", music_icon, update_music_mute),
        create_slider(Sound.sfxVolume, update_sfx_slider),
        create_button("", sfx_icon, update_sfx_mute),
        create_button("", home_icon, on_home_release),
        create_button("", return_icon, on_reset_release),
        create_button("", next_icon, on_skip_release)
    ):setOpaque(true):setVisible(false)

    return panel
end

return UI
