local Elements = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/glass-ui/refs/heads/main/Core/Elements.lua"))()

local Tabs = {}

function Tabs:Init(Library)

    function Library:CreateTab(name, icon)

        local Theme = self.CurrentTheme

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 32)
        Button.Text = name
        Button.BackgroundColor3 = Theme.Background
        Button.BackgroundTransparency = 0.3
        Button.TextColor3 = Theme.Text
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 13
        Button.Parent = self._TabButtons

        local corner = Instance.new("UICorner", Button)
        corner.CornerRadius = UDim.new(0, 8)

        local Container = Instance.new("ScrollingFrame")
        Container.Size = UDim2.new(1, 0, 1, 0)
        Container.CanvasSize = UDim2.new(0, 0, 0, 0)
        Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Container.ScrollBarThickness = 4
        Container.BackgroundTransparency = 1
        Container.Visible = false
        Container.Parent = self._TabContainer

        local Layout = Instance.new("UIListLayout", Container)
        Layout.Padding = UDim.new(0, 6)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder

        -- Tab switch
        Button.MouseButton1Click:Connect(function()
            for _,v in pairs(self._TabContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            Container.Visible = true
        end)

        -- First tab auto-open
        if #self._TabContainer:GetChildren() == 1 then
            Container.Visible = true
        end

        return Elements:CreateTab(self, Container)
    end
end

return Tabs
