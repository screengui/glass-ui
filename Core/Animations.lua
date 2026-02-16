local TweenService = game:GetService("TweenService")

local Animations = {}

function Animations:Tween(obj, props, time)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props
    )
    tween:Play()
    return tween
end

return Animations
