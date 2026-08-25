local json = require "src/lib/json"
local Utils = require "src/utils/utils"
local Sound = require "src/misc/sound"

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
local wav = ".wav"
local mp3 = ".mp3"
local sfx_type = "static"
local music_type = "stream"
local sfx_path = "/data/audio/sfx/"
local music_path = "/data/audio/music/"
local function sfx(name, type) return (sfx_path .. name .. type) end
local function music(name, type) return (music_path .. name .. type) end

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

local function load_audio(name, ext, type)
    local path = ""
    if type == sfx_type then path = sfx(name, ext)
    elseif type == music_type then path = music(name, ext)
    end

    if lf.getInfo(path) then
        audio[name] = Sound(path, type)
        return audio[name]
    end
end

function Resources.load_image(name)
    if Utils:find_index(images, name) then return images[name] end
    local path = image(name)
    if lf.getInfo(path) then
        images[name] = lg.newImage(path)
        return images[name]
    end
    error("Image Error: Image at " .. path .. " could not be found.")
end

function Resources.load_font(name, size)
    if Utils:find_index(fonts, name) then return fonts[name] end
    local path = font(name)
    if lf.getInfo(path) then
        fonts[name] = lg.newFont(path, size)
        return fonts[name]
    end
    error("Font Error: Font at " .. path .. " could not be found.")
end

function Resources.load_data(name)
    if Utils.find_index(data, name) then return data[name] end
    local path = datum(name)
    if lf.getInfo(path) then
        data[name] = json.decode(lf.read(path))
        return data[name]
    end
    error("Data Error: Data at " .. path .. " could not be found.")
end

function Resources.load_music(name)
    if Utils.find_index(audio, name) then return audio[name] end
    local file = load_audio(name, wav, music_type)
    if file then return file else
        file = load_audio(name, mp3, music_type)
        if file then return file end
    end
    error("Music Error: Music at " .. path .. " could not be found.")
end

function Resources.load_sfx(name)
    if Utils.find_index(audio, name) then return audio[name] end
    local file = load_audio(name, wav, sfx_type)
    if file then return file else
        file = load_audio(name, mp3, sfx_type)
        if file then return file end
    end
    error("SFX Error: SFX at " .. path .. " could not be found.")
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
    if error then error("Save Error: " .. error) end
end

function Resources.load()
    if lf.getInfo(file_name) then
        local info, message = json.decode(lf.read(file_name))
        if message == nil then
            save_data = info
        else error("Load Error: " .. message) end
    else
        save_data = default_save_data
        
        local _, error = lf.write(file_name, json.encode(save_data))
        if error then error("Save Error: " .. error) end
    end

    Sound.sfxMute = save_data.sfxMute
    Sound.sfxVolume = save_data.sfxVolume
    Sound.musicMute = save_data.musicMute
    Sound.musicVolume = save_data.musicVolume

    Resources.set_audio_volume()
end

return Resources
