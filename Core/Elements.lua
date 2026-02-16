local Animations = require(script.Parent.Animations)

local Elements = {}

function Elements:CreateTab(Library, Container)

    local Tab = {}

    function Tab:AddButton(options)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -4, 0, 34)
        Button.Text = options.Name
        Button.BackgroundTransparency = 0.2
        Button.BackgroundColor3 = Library.CurrentTheme.Background
        Button.TextColor3 = Library.CurrentTheme.Text
        Button.Parent = Container

        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

        Button.MouseButton1Click:Connect(function()
            if options.Callback then
                options.Callback()
            end
        end)
    end

    function Tab:AddToggle(options)
        local flag = options.Flag
        local state = options.Default or false

        Library.Flags[flag] = state

        local Toggle = Instance.new("TextButton")
        Toggle.Size = UDim2.new(1, -4, 0, 34)
        Toggle.Text = options.Name .. ": " .. tostring(state)
        Toggle.BackgroundTransparency = 0.2
        Toggle.BackgroundColor3 = Library.CurrentTheme.Background
        Toggle.TextColor3 = Library.CurrentTheme.Text
        Toggle.Parent = Container

        Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 8)

        Toggle.MouseButton1Click:Connect(function()
            state = not state
            Library.Flags[flag] = state
            Toggle.Text = options.Name .. ": " .. tostring(state)

            if options.Callback then
                options.Callback(state)
            end

            Library:Save()
        end)
    end

    function Tab:AddSlider(options)
        local flag = options.Flag
        local value = options.Default or options.Min

        Library.Flags[flag] = value

        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, -4, 0, 40)
        Frame.BackgroundTransparency = 1
        Frame.Parent = Container

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 16)
        Label.BackgroundTransparency = 1
        Label.Text = options.Name .. ": " .. value
        Label.TextColor3 = Library.CurrentTheme.Text
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 12
        Label.Parent = Frame

        local Slider = Instance.new("TextButton")
        Slider.Size = UDim2.new(1, 0, 0, 18)
        Slider.Position = UDim2.new(0, 0, 0, 20)
        Slider.BackgroundColor3 = Library.CurrentTheme.Background
        Slider.Text = ""
        Slider.Parent = Frame

        local dragging = false

        Slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)

        Slider.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        Slider.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local percent = (input.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X
                percent = math.clamp(percent, 0, 1)

                value = math.floor(options.Min + (options.Max - options.Min) * percent)
                Library.Flags[flag] = value
                Label.Text = options.Name .. ": " .. value

                if options.Callback then
                    options.Callback(value)
                end

                Library:Save()
            end
        end)
    end

    return Tab
end

return Elements
