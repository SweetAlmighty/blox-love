local buttonPress = Resources.LoadSFX('Switch sounds 2')
local style = {
    bgColor = { 0.5, 0.5, 1 },
    font = Resources.LoadFont("Uni Sans Heavy", 30),
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

	createModal = function(text, ok)
	    buttonPress:play()
	    gooi.confirm({
	        text = text,
	        okText = 'Y',
	        cancelText = 'N',
	        ok = function()
	        	buttonPress:play()
	        	ok()
	        end,
	        cancel = function()
	        	buttonPress:play()
	        end
	    })
	end,

	createPanel = function(title, info, type, width, height)
		local grid = info
		grid.layout = type .. " " .. width .. "x" .. height

		local panel = gooi.newPanel(grid)
		panel:setColspan(1, 1, height)
		panel:add(gooi.newLabel({text = title}):center())

		return panel
	end,

	createAlert = function(title, text, ok)
	    gooi.alert({
	        ok = ok,
	        text = title,
	        okText = text
	    })
	end
}