local json = require "src/lib/json"
local Utils = require "src/utils/util"
local Sound = require "src/utils/sound"

local Resources = { }

local fonts = {}
local font_type = ".otf"
local font_path = "/data/fonts/"
local function font(name) return (font_path .. name .. font_type) end

local data = {}
local data_type = ".json"
local data_path = "/data/json/"
local function datum(name) return (data_path .. name .. data_type) end

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

local save_data = { }

local file_name = "savedata.json"

local default_save_data = {
    sfxMute = false,
    sfxVolume = 0.5,
    musicMute = false,
    musicVolume = 0.5,
}

local lf = love.filesystem
lf.setIdentity("blox-love")

local lg = love.graphics
lg.setDefaultFilter("nearest", "nearest")

function Resources.load_image(name)
    if Utils:find_index(images, name) then return images[name] end
    local path = image(name)
    if lf.getInfo(path) then
        images[name] = lg.newImage(path)
        return images[name]
    end
    print("Image Error: Image at " .. path .. " could not be found.")
end

function Resources.load_font(name, size)
    if Utils:find_index(fonts, name) then return fonts[name] end
    local path = font(name)
    if lf.getInfo(path) then
        fonts[name] = lg.newFont(path, size)
        return fonts[name]
    end
    print("Font Error: Font at " .. path .. " could not be found.")
end

function Resources.load_data(name)
    if Utils.find_index(data, name) then return data[name] end
    local path = datum(name)
    if lf.getInfo(path) then
        data[name] = json.decode(lf.read(path))
        return data[name]
    end
    print("Data Error: Data at " .. path .. " could not be found.")
end

function Resources.load_music(name)
    if Utils.find_index(audio, name) then return audio[name] end
    local path = music(name)
    if lf.getInfo(path) then
        audio[name] = Sound(path, "stream")
        return audio[name]
    end
    print("Music Error: Music at " .. path .. " could not be found.")
end

function Resources.load_sfx(name)
    if Utils.find_index(audio, name) then return audio[name] end
    local path = sfx(name)
    if lf.getInfo(path) then
        audio[name] = Sound(path, "static")
        return audio[name]
    end
    print("SFX Error: SFX at " .. path .. " could not be found.")
end

function Resources.set_audio_volume()
    for _, v in pairs(audio) do v:set_volume() end
end

function Resources.save()
    save_data.sfxMute = Sound.sfxMute
    save_data.sfxVolume = Sound.sfxVolume
    save_data.musicMute = Sound.musicMute
    save_data.musicVolume = Sound.musicVolume

    local _, error = lf.write(file_name, json.encode(save_data))
    if error then print("Save Error: " .. error) end
end

function Resources.load()
    if lf.getInfo(file_name) then
        local info, message = json.decode(lf.read(file_name))
        if message == nil then
            save_data = info
        else print("Load Error: " .. message) end
    else
        save_data = default_save_data
        
        local _, error = lf.write(file_name, json.encode(save_data))
        if error then print("Save Error: " .. error) end
    end

    Sound.sfxMute = save_data.sfxMute
    Sound.sfxVolume = save_data.sfxVolume
    Sound.musicMute = save_data.musicMute
    Sound.musicVolume = save_data.musicVolume

    Resources.set_audio_volume()
end

return Resources
