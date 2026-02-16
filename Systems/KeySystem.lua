local KeySystem = {}

function KeySystem:Start(Library, callback)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 150)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    Frame.Parent = ScreenGui

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(1, -20, 0, 40)
    Box.Position = UDim2.new(0, 10, 0, 40)
    Box.PlaceholderText = "Enter Key"
    Box.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 30)
    Button.Position = UDim2.new(0, 10, 0, 90)
    Button.Text = "Submit"
    Button.Parent = Frame

    local function Verify(key)

        if Library.Config.KeyType == "Static" then
            return key == Library.Config.StaticKey

        elseif Library.Config.KeyType == "Time" then
            return tonumber(key) and tonumber(key) > os.time()

        elseif Library.Config.KeyType == "HWID" then
            return key == game:GetService("RbxAnalyticsService"):GetClientId()

        elseif Library.Config.KeyType == "HTTP" then
            local response = game:HttpGet(Library.Config.KeyURL .. key)
            return response == "true"
        end

        return false
  end

    Button.MouseButton1Click:Connect(function()
        if Verify(Box.Text) then
            ScreenGui:Destroy()
            callback()
        else
            Box.Text = "Invalid key"
        end
    end)
end

return KeySystem
