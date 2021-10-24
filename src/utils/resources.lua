require "src/utils/sound"
local json = require "src/lib/json"

local lg = love.graphics
local lf = love.filesystem

local fonts = {}
local font_type = ".otf"
local font_path = "/data/fonts/"
local function font(name) return (font_path .. name .. font_type) end

local anims = {}
local anim_type = ".json"
local anim_path = "/data/images/anims/"
local function anim(name) return (anim_path .. name .. anim_type) end

local sheets = {}
local sheet_type = ".json"
local sheet_path = "/data/images/sheet/"
local function sheet(name) return (sheet_path .. name .. sheet_type) end

local images = {}
local image_type = ".png"
local image_path = "/data/images/"
local function image(name) return (image_path .. name .. image_type) end

local audio = {}
local audio_type = ".wav"
local sfx_path = "/data/audio/sfx/"
local music_path = "/data/audio/music/"
local function sfx(name) return (sfx_path .. name .. audio_type) end
local function music(name) return (music_path .. name .. audio_type) end

lg.setDefaultFilter("nearest", "nearest")

Resources = {
    LoadImage = function(name)
        if find_index(images, name) then return images[name] end
        local path = image(name)
        if lf.getInfo(path) then
            images[name] = lg.newImage(path)
            --images[name]:setFilter("nearest", "nearest")
            return images[name]
        end
        print("Image Error: Image at " .. path .. " could not be found.")
        return nil
    end,

    LoadFont = function(name, size)
        if find_index(fonts, name) then return fonts[name] end
        local path = font(name)
        if lf.getInfo(path) then
            fonts[name] = lg.newFont(path, size)
            --fonts[name]:setFilter("nearest", "nearest")
            return fonts[name]
        end
        print("Font Error: Font at " .. path .. " could not be found.")
        return nil
    end,

    LoadSheet = function(name)
        if find_index(sheets, name) then return sheets[name] end
        local path = sheet(name)
        if lf.getInfo(path) then
            sheets[name] = json.decode(lf.read(path))
            return sheets[name]
        end
        print("Sheet Error: Sheet at " .. path .. " could not be found.")
        return nil
    end,

    LoadAnim = function(name)
        if find_index(anims, name) then return anims[name] end
        local path = anim(name)
        if lf.getInfo(path) then
            anims[name] = json.decode(lf.read(path))
            return anims[name]
        end
        print("Anim Error: Animation at " .. path .. " could not be found.")
        return nil
    end,

    LoadMusic = function(name)
        if find_index(audio, name) then return audio[name] end
        local path = music(name)
        if lf.getInfo(path) then
            audio[name] = Sound(path, "stream")
            return audio[name]
        end
        print("Music Error: Music at " .. path .. " could not be found.")
        return nil
    end,

    LoadSFX = function(name)
        if find_index(audio, name) then return audio[name] end
        local path = sfx(name)
        if lf.getInfo(path) then
            audio[name] = Sound(path, "static")
            return audio[name]
        end
        print("SFX Error: SFX at " .. path .. " could not be found.")
        return nil
    end
}
