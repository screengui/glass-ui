local Animations = require(script.Parent.Animations)

local Elements = {}

function Elements:CreateTab(Library, Container)

    local Tab = {}

    local function BaseFrame(height)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, -4, 0, height)
        Frame.BackgroundTransparency = 1
        Frame.Parent = Container
        return Frame
    end

    local function BaseButton(text, parent)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.BackgroundColor3 = Library.CurrentTheme.Background
        Button.BackgroundTransparency = 0.2
        Button.TextColor3 = Library.CurrentTheme.Text
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 13
        Button.Text = text
        Button.Parent = parent

        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
        return Button
    end
    
    function Tab:AddButton(options)
        local Frame = BaseFrame(34)
        local Button = BaseButton(options.Name, Frame)

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

        local Frame = BaseFrame(34)
        local Button = BaseButton(options.Name .. ": " .. tostring(state), Frame)

        Button.MouseButton1Click:Connect(function()
            state = not state
            Library.Flags[flag] = state
            Button.Text = options.Name .. ": " .. tostring(state)

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

    function Tab:AddTextbox(options)
        local flag = options.Flag
        local value = options.Default or ""
        Library.Flags[flag] = value

        local Frame = BaseFrame(36)

        local Box = Instance.new("TextBox")
        Box.Size = UDim2.new(1, 0, 1, 0)
        Box.Text = value
        Box.PlaceholderText = options.Name
        Box.BackgroundColor3 = Library.CurrentTheme.Background
        Box.BackgroundTransparency = 0.2
        Box.TextColor3 = Library.CurrentTheme.Text
        Box.Font = Enum.Font.Gotham
        Box.TextSize = 13
        Box.Parent = Frame

        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 8)

        Box.FocusLost:Connect(function()
            Library.Flags[flag] = Box.Text
            if options.Callback then
                options.Callback(Box.Text)
            end
            Library:Save()
        end)
    end

    function Tab:AddDropdown(options)
        local flag = options.Flag
        local value = options.Default or options.List[1]
        Library.Flags[flag] = value

        local Frame = BaseFrame(34)
        local Button = BaseButton(options.Name .. ": " .. value, Frame)

        Button.MouseButton1Click:Connect(function()
            local menu = Instance.new("Frame")
            menu.Size = UDim2.new(1, 0, 0, #options.List * 28)
            menu.Position = UDim2.new(0, 0, 1, 4)
            menu.BackgroundTransparency = 1
            menu.Parent = Frame

            local layout = Instance.new("UIListLayout", menu)
            layout.Padding = UDim.new(0, 4)

            for _,item in ipairs(options.List) do
                local opt = BaseButton(item, menu)
                opt.Size = UDim2.new(1, 0, 0, 26)

                opt.MouseButton1Click:Connect(function()
                    value = item
                    Library.Flags[flag] = value
                    Button.Text = options.Name .. ": " .. value
                    menu:Destroy()

                    if options.Callback then
                        options.Callback(value)
                    end

                    Library:Save()
                end)
            end
        end)
    end

    function Tab:AddMultiDropdown(options)
        local flag = options.Flag
        local values = {}
        Library.Flags[flag] = values

        local Frame = BaseFrame(34)
        local Button = BaseButton(options.Name, Frame)

        Button.MouseButton1Click:Connect(function()
            local menu = Instance.new("Frame")
            menu.Size = UDim2.new(1, 0, 0, #options.List * 28)
            menu.Position = UDim2.new(0, 0, 1, 4)
            menu.BackgroundTransparency = 1
            menu.Parent = Frame

            local layout = Instance.new("UIListLayout", menu)
            layout.Padding = UDim.new(0, 4)

            for _,item in ipairs(options.List) do
                local opt = BaseButton(item, menu)
                opt.Size = UDim2.new(1, 0, 0, 26)

                opt.MouseButton1Click:Connect(function()
                    if values[item] then
                        values[item] = nil
                    else
                        values[item] = true
                    end

                    Library.Flags[flag] = values

                    if options.Callback then
                        options.Callback(values)
                    end

                    Library:Save()
                end)
            end
        end)
    end

    function Tab:AddKeybind(options)
        local flag = options.Flag
        local key = options.Default or Enum.KeyCode.Unknown
        Library.Flags[flag] = key

        local Frame = BaseFrame(34)
        local Button = BaseButton(options.Name .. ": " .. key.Name, Frame)

        local waiting = false

        Button.MouseButton1Click:Connect(function()
            Button.Text = "Press a key..."
            waiting = true
        end)

        UIS.InputBegan:Connect(function(input, gpe)
            if waiting and not gpe then
                key = input.KeyCode
                Library.Flags[flag] = key
                Button.Text = options.Name .. ": " .. key.Name
                waiting = false
                Library:Save()
            end
        end)
    end

    function Tab:AddColorPicker(options)
        local flag = options.Flag
        local color = options.Default or Color3.new(1,1,1)
        Library.Flags[flag] = color

        local Frame = BaseFrame(34)
        local Button = BaseButton(options.Name, Frame)
        Button.BackgroundColor3 = color

        Button.MouseButton1Click:Connect(function()
            color = Color3.fromHSV(math.random(),1,1)
            Library.Flags[flag] = color
            Button.BackgroundColor3 = color

            if options.Callback then
                options.Callback(color)
            end

            Library:Save()
        end)
    end
    
    return Tab
end

return Elements
