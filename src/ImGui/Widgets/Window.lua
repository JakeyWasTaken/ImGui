local Components = script.Parent.Parent:WaitForChild("Components")
local Internal = require(Components:WaitForChild("Internal"))
local Types = require(Components:WaitForChild("Types"))
local Pointer = require(Components:WaitForChild("Pointer"))
local Style = require(Components:WaitForChild("Style"))

type Pointer<T> = Pointer.Pointer<T>

local Window = {}

function Window.Generate(Widget: Types.ImGuiWindow): ScreenGui
    local Window

    local Context = Internal.Context
    local Style = Context.ActiveStyle

    local function ZIndex(NoIncrement)
        Widget.ZIndex += NoIncrement and 0 or 1
        return Widget.ZIndex
    end

    if Style.UseScreenGUIs then
        Window = Instance.new("ScreenGui")
        Window.ResetOnSpawn = false
        Window.Enabled = false
        Window.IgnoreGuiInset = Style.IgnoreGuiInset
        Window.DisplayOrder = Style.DisplayOrderOffset
    else
        Window = Instance.new("Folder")
    end
    Window.Name = "ImGuiWindow"

    local WindowButton: TextButton = Instance.new("TextButton")
    WindowButton.Name = "WindowButton"
    WindowButton.Size = UDim2.fromOffset(0, 0)
    WindowButton.BackgroundTransparency = 1
    WindowButton.BorderSizePixel = 0
    WindowButton.Text = ""
    WindowButton.AutomaticSize = Enum.AutomaticSize.XY
    WindowButton.ClipsDescendants = false
    WindowButton.AutoButtonColor = false
    WindowButton.Selectable = false
    WindowButton.SelectionImageObject = Internal.SelectionImageObject
    WindowButton.ZIndex = 1
    WindowButton.LayoutOrder = 1

    local Borders = Instance.new("Folder")
    Borders.Name = "Borders"

    local TopBorder = Instance.new("Frame")
    TopBorder.Name = "Top"
    TopBorder.AnchorPoint = Vector2.new(0, 1)
    TopBorder.BackgroundColor3 = Style.BorderColor
    TopBorder.BackgroundTransparency = Style.BorderTransparency
    TopBorder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TopBorder.BorderSizePixel = 0
    TopBorder.Size = UDim2.new(1, 0, 0, 1)
    TopBorder.Parent = Borders

    local BottomBorder = Instance.new("Frame")
    BottomBorder.Name = "Bottom"
    BottomBorder.BackgroundColor3 = Style.BorderColor
    BottomBorder.BackgroundTransparency = Style.BorderTransparency
    BottomBorder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BottomBorder.BorderSizePixel = 0
    BottomBorder.Position = UDim2.new(0, 0, 1, -1)
    BottomBorder.Size = UDim2.new(1, 0, 0, 1)
    BottomBorder.Parent = Borders

    local LeftBorder = Instance.new("Frame")
    LeftBorder.Name = "Left"
    LeftBorder.AnchorPoint = Vector2.new(1, 1)
    LeftBorder.BackgroundColor3 = Style.BorderColor
    LeftBorder.BackgroundTransparency = Style.BorderTransparency
    LeftBorder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LeftBorder.BorderSizePixel = 0
    LeftBorder.Position = UDim2.fromScale(0, 1)
    LeftBorder.Size = UDim2.new(0, 1, 1, 1)
    LeftBorder.Parent = Borders

    local RightBorder = Instance.new("Frame")
    RightBorder.Name = "Right"
    RightBorder.AnchorPoint = Vector2.new(0, 1)
    RightBorder.BackgroundColor3 = Style.BorderColor
    RightBorder.BackgroundTransparency = Style.BorderTransparency
    RightBorder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    RightBorder.BorderSizePixel = 0
    RightBorder.Position = UDim2.fromScale(1, 1)
    RightBorder.Size = UDim2.new(0, 1, 1, 1)
    RightBorder.Parent = Borders

    Borders.Parent = WindowButton

    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.AutomaticSize = Enum.AutomaticSize.Y
    TitleBar.BackgroundColor3 = Style.TitleBgActiveColor
    TitleBar.BackgroundTransparency = Style.TitleBgActiveTransparency
    TitleBar.BorderSizePixel = 0
    TitleBar.ClipsDescendants = true
    TitleBar.LayoutOrder = ZIndex()
    TitleBar.Size = UDim2.fromScale(1, 0)
    TitleBar.ZIndex = ZIndex(true)

    local TitleButtonSize = Style.TextSize + ((Style.FramePadding.Y - 1) * 2)

    local CollapseCircle = Instance.new("ImageLabel")
    CollapseCircle.Name = "CollapseCircle"
    CollapseCircle.Image = "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble2.png"
    CollapseCircle.ImageColor3 = Style.ButtonColor
    CollapseCircle.AnchorPoint = Vector2.new(0, 0.5)
    CollapseCircle.BackgroundTransparency = 1
    CollapseCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    CollapseCircle.BorderSizePixel = 0
    CollapseCircle.Position = UDim2.new(0, Style.FramePadding.X + 1, 0.5, 0)
    CollapseCircle.Size = UDim2.fromOffset(TitleButtonSize, TitleButtonSize)
    CollapseCircle.ZIndex = ZIndex()
    CollapseCircle.Parent = TitleBar

    local CollapseButton = Instance.new("TextButton")
    CollapseButton.Name = "CollapseButton"
    CollapseButton.Text = Style.ARROW_DOWN
    CollapseButton.FontFace = Style.TextFont
    CollapseButton.TextColor3 = Style.TextColor
    CollapseButton.TextSize = Style.TextSize - 4
    CollapseButton.TextXAlignment = Enum.TextXAlignment.Left
    CollapseButton.TextYAlignment = Enum.TextYAlignment.Top
    CollapseButton.AutoButtonColor = false
    CollapseButton.AnchorPoint = Vector2.new(0, 0.5)
    CollapseButton.BackgroundTransparency = 1
    CollapseButton.BorderSizePixel = 0
    CollapseButton.Position = UDim2.new(0, Style.FramePadding.X + 1, 0.5, 0)
    CollapseButton.Size = UDim2.fromOffset(TitleButtonSize, TitleButtonSize)
    CollapseButton.ZIndex = ZIndex()

    local UIPadding = Instance.new("UIPadding")
    UIPadding.Name = "UIPadding"
    UIPadding.PaddingLeft = UDim.new(0, 2)
    UIPadding.PaddingTop = UDim.new(0, 3)
    UIPadding.Parent = CollapseButton

    CollapseButton.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.FontFace = Style.TextFont
    Title.Text = "ImGui Window"
    Title.TextColor3 = Style.TextColor
    Title.TextSize = Style.TextSize
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.AutomaticSize = Enum.AutomaticSize.XY
    Title.BackgroundTransparency = 1
    Title.BorderSizePixel = 0
    Title.ZIndex = ZIndex()
    Title.AutoLocalize = false

    local UIPadding1 = Instance.new("UIPadding")
    UIPadding1.Name = "UIPadding"
    UIPadding1.PaddingBottom = UDim.new(0, 3)
    UIPadding1.PaddingLeft = UDim.new(0, 25)
    UIPadding1.PaddingRight = UDim.new(0, 4)
    UIPadding1.PaddingTop = UDim.new(0, 3)
    UIPadding1.Parent = Title

    Title.Parent = TitleBar

    local UIPadding2 = Instance.new("UIPadding")
    UIPadding2.Name = "UIPadding"
    UIPadding2.PaddingTop = UDim.new(0, -1)
    UIPadding2.Parent = TitleBar

    local CloseCircle = Instance.new("ImageLabel")
    CloseCircle.Name = "CloseCircle"
    CloseCircle.Image = "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble2.png"
    CloseCircle.ImageColor3 = Style.ButtonColor
    CloseCircle.AnchorPoint = Vector2.new(1, 0.5)
    CloseCircle.BackgroundTransparency = 1
    CloseCircle.BorderSizePixel = 0
    CloseCircle.Position = UDim2.new(1, -(Style.FramePadding.X + 1), 0.5, 0)
    CloseCircle.Size = UDim2.fromOffset(TitleButtonSize, TitleButtonSize)
    CloseCircle.ZIndex = ZIndex()
    CloseCircle.Parent = TitleBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Text = Style.CROSS
    CloseButton.FontFace = Style.TextFont
    CloseButton.TextColor3 = Style.TextColor
    CloseButton.TextSize = Style.TextSize + 4
    CloseButton.TextXAlignment = Enum.TextXAlignment.Left
    CloseButton.TextYAlignment = Enum.TextYAlignment.Top
    CloseButton.AutoButtonColor = false
    CloseButton.AnchorPoint = Vector2.new(1, 0.5)
    CloseButton.BackgroundTransparency = 1
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -(Style.FramePadding.X + 1), 0.5, 0)
    CloseButton.Size = UDim2.fromOffset(TitleButtonSize, TitleButtonSize)
    CloseButton.ZIndex = ZIndex()

    local UIPadding3 = Instance.new("UIPadding")
    UIPadding3.Name = "UIPadding"
    UIPadding3.PaddingLeft = UDim.new(0, 2)
    UIPadding3.PaddingTop = UDim.new(0, -2)
    UIPadding3.Parent = CloseButton

    CloseButton.Parent = TitleBar



    TitleBar.Parent = WindowButton
    WindowButton.Parent = Window
    Window.Parent = Internal.RenderTarget

    return Window
end

function Window.DetermineWindowSize(Widget: Types.ImGuiWindow)
    local Window = Widget.Instance
    local State = Widget.State

    local WindowButton: Frame = Window.WindowButton
    local WindowAbsSize = WindowButton.AbsoluteSize:Max(Internal.Context.ActiveStyle.MinimumWindowSize)

    State.Size = WindowAbsSize

    WindowButton.AutomaticSize = Enum.AutomaticSize.None
    WindowButton.Size = UDim2.fromOffset(WindowAbsSize.X, WindowAbsSize.Y)
    Window.Enabled = true
end

function Window.Update(Widget: Types.ImGuiWindow, Title: string | Pointer<string>, Open: boolean | Pointer<boolean>, Flags: Types.ImGuiWindowFlags)
    local Window = Widget.Instance
    local State = Widget.State

    local WindowButton: Frame = Window.WindowButton
end

function Window.UpdateState(Widget: Types.ImGuiWindow)

end

return Window
