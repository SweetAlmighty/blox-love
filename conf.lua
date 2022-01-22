function love.conf(t)
    t.version = "11.4"                  -- The LÖVE version this game was made for (string)
    t.console = false                   -- Attach a console (boolean, Windows only)
    t.gammacorrect = false              -- Enable gamma-correct rendering, when supported by the system (boolean)
    t.externalstorage = false           -- True to save files (and read from the save directory) in external storage on Android (boolean)
    t.accelerometerjoystick = true      -- Enable the accelerometer on iOS and Android by exposing it as a Joystick (boolean)

    t.audio.mic = false                 -- Request and use microphone capabilities in Android (boolean)
    t.audio.mixwithsystem = true        -- Keep background music playing when opening LOVE (boolean, iOS and Android only)

    t.window.x = nil                    -- The x-coordinate of the window's position in the specified display (number)
    t.window.y = nil                    -- The y-coordinate of the window's position in the specified display (number)
    t.window.msaa = 0                   -- The number of samples to use with multi-sampled antialiasing (number)
    t.window.vsync = 1                  -- Vertical sync mode (number)
    t.window.icon = nil                 -- Filepath to an image to use as the window's icon (string)
    t.window.depth = nil                -- The number of bits per sample in the depth buffer
    t.window.display = 1                -- Index of the monitor to show the window in (number)
    t.window.minwidth = 1               -- Minimum window width if the window is resizable (number)
    t.window.minheight = 1              -- Minimum window height if the window is resizable (number)
    t.window.stencil = nil              -- The number of bits per sample in the stencil buffer
    t.window.title = "Blox"             -- The window title (string)
    t.window.fullscreentype = "desktop" -- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)

    t.modules.data = false              -- Enable the data module (boolean)
    t.modules.thread = false            -- Enable the thread module (boolean)
    t.modules.physics = false           -- Enable the physics module (boolean)
    t.modules.joystick = true           -- Enable the joystick module (boolean)
end
