local UIS = game:GetService("UserInputService")

local KeybindHandler = {}

function KeybindHandler:Init(Library)

    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end

        for flag, key in pairs(Library.Flags) do
            if typeof(key) == "EnumItem" and input.KeyCode == key then
                print("Keybind triggered:", flag)
            end
        end
    end)
end

return KeybindHandler
