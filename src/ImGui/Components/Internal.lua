local Internal = {}

Internal.IdStack = {}
Internal.RenderTarget = nil
Internal.CycleId = 0
Internal.Context = {
    DOM = {},
    LastDOM = {},
    ActiveWindow = nil,
    ActiveStyle = nil,
}

function Internal.GenerateSelectionImageObject()
    if Internal.SelectionImageObject then
        Internal.SelectionImageObject:Destroy()
    end

    local g = Internal.Context

    local SelectionImageObject: Frame = Instance.new("Frame")
    SelectionImageObject.Position = UDim2.fromOffset(-1, -1)
    SelectionImageObject.Size = UDim2.new(1, 2, 1, 2)
    SelectionImageObject.BackgroundColor3 = g.ActiveStyle.SelectionImageObjectColor
    SelectionImageObject.BackgroundTransparency = g.ActiveStyle.SelectionImageObjectTransparency
    SelectionImageObject.BorderSizePixel = 0

    local UIStroke: UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 1
    UIStroke.Color = g.ActiveStyle.SelectionImageObjectBorderColor
    UIStroke.Transparency = g.ActiveStyle.SelectionImageObjectBorderColor
    UIStroke.LineJoinMode = Enum.LineJoinMode.Round
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    UIStroke.Parent = SelectionImageObject

    local Rounding: UICorner = Instance.new("UICorner")
    Rounding.CornerRadius = UDim.new(0, 2)

    Rounding.Parent = SelectionImageObject

    Internal.SelectionImageObject = SelectionImageObject
end

function Internal.UIPadding(Parent: Instance, Top: number, Bottom: number, Left: number, Right: number)
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, Top)
    UIPadding.PaddingBottom = UDim.new(0, Bottom)
    UIPadding.PaddingLeft = UDim.new(0, Left)
    UIPadding.PaddingRight = UDim.new(0, Right)
    UIPadding.Parent = Parent

    return UIPadding
end

return Internal
