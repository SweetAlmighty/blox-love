local Resources = require "src/utils/resources"

local UI = {}

local style = {
    bgColor = { 0.5, 0.5, 1 },
    font = Resources.load_font("Uni Sans Heavy", 30),
}

local buttonPress = Resources.load_sfx('Switch sounds 2')

local getWidth = love.graphics.getWidth
local getHeight = love.graphics.getHeight

function UI.set_start_style() gooi.setStyle(style) end

function UI.icon_path(name) return "data/images/" .. name .. ".png" end

function UI.create_button(text, icon, onRelease)
	local btn

	local updateIcon = function()
	    if icon then btn:setIcon(UI.icon_path(icon())) end
	end

	btn = gooi.newButton({text = text})
				:onRelease(function()
					buttonPress:play()
					onRelease()
					updateIcon()
				end)

    updateIcon()

    return btn
end

function UI.create_slider(value, onUpdate)
    return gooi.newSlider({value = value})
	            :setOnValueUpdated(function(v)
	            	onUpdate(v)
	            end)
end

function UI.create_modal(text, style, ok)
    buttonPress:play()
    gooi.panelDialog = UI.create_panel("", {
	    x = getWidth()/2.67,
	    y = getHeight()/3,
	    w = getWidth()/4,
	    h = getHeight()/3
	}, "grid", 3, 3):setOpaque(true):warning()

	local cancel = function()
		buttonPress:play()
		gooi.showingDialog = false
		gooi.removeComponent(gooi.panelDialog)
	end

	local continue = function()
		cancel()
		if ok ~= nil then ok() end
	end

	local cross = function() return "cross" end
	local checkmark = function() return "checkmark" end

	gooi.lblDialog = gooi.newLabel({ text = text }):center()
	gooi.lblDialog.lblFlag = true
    gooi.panelDialog:add(gooi.lblDialog, "2,2")

	if style == "modal" then
    	gooi.yesButton = UI.create_button("", checkmark, continue):warning()
      	gooi.yesButton.yesFlag = true
	    gooi.panelDialog:add(gooi.yesButton, "3,3")

    	gooi.noButton = UI.create_button("", cross, cancel):warning()
      	gooi.noButton.noFlag = true
	    gooi.panelDialog:add(gooi.noButton, "3,1")
	else
		gooi.okButton = UI.create_button("", checkmark, continue):warning()
		gooi.okButton.okFlag = true
	    gooi.panelDialog:add(gooi.okButton, "3,2")
	end

    gooi.showingDialog = true
end

function UI.create_panel(title, info, type, width, height)
	info.layout = type .. " " .. width .. "x" .. height

	local panel = gooi.newPanel(info)
	panel:setColspan(1, 1, height)
	panel:add(gooi.newLabel({text = title}):center())

	return panel
end

return UI
