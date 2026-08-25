local State = require "src/states/state"

local SplashScreen = State:extend()
function SplashScreen:type() return self._type end
function SplashScreen:new() self._type = State.GameStates.SplashScreen end
return SplashScreen
