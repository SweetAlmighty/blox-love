require "src/ui/settingsui"

Settings = State:extend()

function Settings:new() self.ui = SettingsUI() end
function Settings:enter() self.ui:set_visible(true) end
function Settings:exit() self.ui:set_visible(false) end
