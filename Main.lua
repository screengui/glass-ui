local Library = {}

Library.Config = {
    Name = "GlassUI",
    Theme = "GlassDark",
    ToggleKey = Enum.KeyCode.RightControl,
    KeySystem = false,
    KeyType = "Static", -- Static / Time / HWID / HTTP
    SaveConfig = true,
    ConfigFolder = "GlassUI",
    ConfigFile = "config.json"
}

Library.Flags = {}
Library.Tabs = {}
Library.ThemeObjects = {}

-- Services
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

-- Modules
local Animations = require(script.Core.Animations)
local Themes = require(script.Core.Themes)
local Config = require(script.Core.Config)
local Window = require(script.Core.Window)
local KeySystem = require(script.Systems.KeySystem)

function Library:Init(options)
    for i,v in pairs(options) do
        self.Config[i] = v
    end

    self.CurrentTheme = Themes[self.Config.Theme]

    if self.Config.KeySystem then
        KeySystem:Start(self, function()
            Window:Create(self)
        end)
    else
        Window:Create(self)
    end
end

function Library:Save()
    if self.Config.SaveConfig then
        Config:Save(self)
    end
end

function Library:Load()
    if self.Config.SaveConfig then
        Config:Load(self)
    end
end

return Library
