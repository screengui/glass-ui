local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Tabs = require(script.Parent.Tabs)
local Animations = require(script.Parent.Animations)

local Window = {}

function Window:Create(Library)

    local Theme = Library.CurrentTheme

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = Library.Config.Name
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 520, 0, 420)
    Main.Position = UDim2.new(0.5, -260, 0.5, -210)
    Main.BackgroundColor3 = Theme.Background
    Main.BackgroundTransparency = Theme.BackgroundTransparency
    Main.Parent = ScreenGui

    local corner = Instance.new("UICorner", Main)
    corner.CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", Main)
    stroke.Color = Theme.Stroke
    stroke.Transparency = 0.5

    -- Topbar
    local Top = Instance.new("Frame")
    Top.Size = UDim2.new(1, 0, 0, 36)
    Top.BackgroundTransparency = 1
    Top.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Library.Config.Name
    Title.TextColor3 = Theme.Text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamSemibold
    Title.TextSize = 14
    Title.Parent = Top

    -- Minimize
    local Min = Instance.new("TextButton")
    Min.Size = UDim2.new(0, 30, 1, 0)
    Min.Position = UDim2.new(1, -60, 0, 0)
    Min.Text = "-"
    Min.BackgroundTransparency = 1
    Min.TextColor3 = Theme.Text
    Min.Font = Enum.Font.GothamBold
    Min.TextSize = 16
    Min.Parent = Top

    -- Close
    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0, 30, 1, 0)
    Close.Position = UDim2.new(1, -30, 0, 0)
    Close.Text = "X"
    Close.BackgroundTransparency = 1
    Close.TextColor3 = Theme.Text
    Close.Font = Enum.Font.GothamBold
    Close.TextSize = 14
    Close.Parent = Top

    -- Body
    local Body = Instance.new("Frame")
    Body.Size = UDim2.new(1, -10, 1, -46)
    Body.Position = UDim2.new(0, 5, 0, 41)
    Body.BackgroundTransparency = 1
    Body.Parent = Main

    -- Tab buttons
    local TabButtons = Instance.new("Frame")
    TabButtons.Size = UDim2.new(0, 120, 1, 0)
    TabButtons.BackgroundTransparency = 1
    TabButtons.Parent = Body

    local TabList = Instance.new("UIListLayout", TabButtons)
    TabList.Padding = UDim.new(0, 6)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder

    -- Tab container
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -130, 1, 0)
    TabContainer.Position = UDim2.new(0, 130, 0, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = Body

    -- Store references
    Library._ScreenGui = ScreenGui
    Library._Main = Main
    Library._TabButtons = TabButtons
    Library._TabContainer = TabContainer

    -- Close logic
    Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Minimize logic
    local minimized = false
    local originalSize = Main.Size

    Min.MouseButton1Click:Connect(function()
        minimized = not minimized

        if minimized then
            Animations:Tween(Main, {Size = UDim2.new(0, 520, 0, 36)}, 0.2)
            Body.Visible = false
        else
            Body.Visible = true
            Animations:Tween(Main, {Size = originalSize}, 0.2)
        end
    end)

    -- Dragging
    local dragging = false
    local dragStart
    local startPos

    Top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- PC toggle key
    UIS.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Library.Config.ToggleKey then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    -- Attach tab system
    Tabs:Init(Library)
end

return Window
