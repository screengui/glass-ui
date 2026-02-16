local UIS = game:GetService("UserInputService")

local MobileToggle = {}

function MobileToggle:Create(Library)

    if not UIS.TouchEnabled then
        return
    end

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 50, 0, 50)
    Button.Position = UDim2.new(0, 20, 0.5, -25)
    Button.Text = "UI"
    Button.Parent = Library._ScreenGui

    Instance.new("UICorner", Button).CornerRadius = UDim.new(1, 0)

    Button.MouseButton1Click:Connect(function()
        Library._Main.Visible = not Library._Main.Visible
    end)
end

return MobileToggle
