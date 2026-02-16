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
local Animations = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/glass-ui/refs/heads/main/Core/Animations.lua"))()
local Themes = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/glass-ui/refs/heads/main/Core/Themes.lua"))()
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/glass-ui/refs/heads/main/Core/Config.lua"))()
local Window = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/glass-ui/refs/heads/main/Core/Window.lua"))()
local KeySystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/glass-ui/refs/heads/main/System/KeySystem.lua"))()

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
