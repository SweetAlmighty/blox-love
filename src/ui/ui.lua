local buttonPress = Resources.load_sfx('Switch sounds 2')
local style = {
    bgColor = { 0.5, 0.5, 1 },
    font = Resources.load_font("Uni Sans Heavy", 30),
}

UI = {
	setStartStyle = function()
    	gooi.setStyle(style)
	end,

	iconPath = function(name)
    	return "data/images/" .. name .. ".png"
	end,

	createButton = function(text, icon, onRelease)
		local btn

		local updateIcon = function()
		    if icon then btn:setIcon(UI.iconPath(icon())) end
		end

		btn = gooi.newButton({text = text})
					:onRelease(function()
						buttonPress:play()
						onRelease()
						updateIcon()
					end)

        updateIcon()

	    return btn
	end,

	createSlider = function(value, onUpdate)
	    return gooi.newSlider({value = value})
		            :setOnValueUpdated(function(v)
		            	onUpdate(v)
		            end)
	end,

	createModal = function(text, style, ok)
		local w = love.graphics.getWidth()
		local h = love.graphics.getHeight()

		local smaller = w < h and w or h

	    local _w = smaller / 2
	    local _h = _w * 0.6

	    buttonPress:play()
	    gooi.panelDialog = UI.createPanel("", {
		    x = w / 2 - _w / 2 / 1,
			y = h / 2 - _h / 2 / 1,
			w = math.floor(_w),
			h = math.floor(_h)
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
	    	gooi.yesButton = UI.createButton("", checkmark, continue):warning()
	      	gooi.yesButton.yesFlag = true
		    gooi.panelDialog:add(gooi.yesButton, "3,3")

	    	gooi.noButton = UI.createButton("", cross, cancel):warning()
	      	gooi.noButton.noFlag = true
		    gooi.panelDialog:add(gooi.noButton, "3,1")
    	else
			gooi.okButton = UI.createButton("", checkmark, continue):warning()
			gooi.okButton.okFlag = true
		    gooi.panelDialog:add(gooi.okButton, "3,2")

    	end

	    gooi.showingDialog = true
	end,

	createPanel = function(title, info, type, width, height)
		local grid = info
		grid.layout = type .. " " .. width .. "x" .. height

		local panel = gooi.newPanel(grid)
		panel:setColspan(1, 1, height)
		panel:add(gooi.newLabel({text = title}):center())

		return panel
	end
}
