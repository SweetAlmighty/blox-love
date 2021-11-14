require "src/ui/ui"

MainMenu = State:extend()

local function on_exit()
    Resources.save()
    love.event.quit()
end

local function on_play_released()
    state_machine:push(GameStates.Gameplay)
end

local function on_exit_released()
    UI.createModal("Exit Blox?", "modal", on_exit)
end

function MainMenu:new()
    MainMenu.super.new(self)
    self._layout = UI.createPanel("BLOX", {x = 0, y = 0, w = 1280, h = 720}, "grid", 5, 3)
    self._layout:add(UI.createButton("PLAY", nil, on_play_released), "3,2")
    self._layout:add(UI.createButton("EXIT", nil, on_exit_released), "4,2")
end

function MainMenu:input(key) end
function MainMenu:update(dt) end
function MainMenu:enter() self._layout:setVisible(true) end
function MainMenu:pause() self._layout:setVisible(false) end
function MainMenu:unpause() self._layout:setVisible(true) end
