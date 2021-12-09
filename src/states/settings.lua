local State = require "src/states/state"
local SettingsUI = require "src/ui/settingsui"

local Settings = State:extend()

function Settings:draw() end
function Settings:new() self.ui = SettingsUI() end
function Settings:enter() self.ui:set_visible(true) end
function Settings:exit() self.ui:set_visible(false) end

return Settings
