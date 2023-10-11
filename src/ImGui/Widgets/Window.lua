local Components = script.Parent.Parent:WaitForChild("Components")
local Internal = require(Components:WaitForChild("Internal"))
local Types = require(Components:WaitForChild("Types"))
local Pointer = require(Components:WaitForChild("Pointer"))
local Style = require(Components:WaitForChild("Style"))

type Pointer<T> = Pointer.Pointer<T>

local Window = {}

function Window.Generate(Widget: Types.ImGuiWindow): ScreenGui
    local Window = Instance.new("ScreenGui")
    Window.ResetOnSpawn = false
    Window.DisplayOrder = 2^16
    Window.Name = "ImGuiWindow"
    Window.Parent = game.Players.LocalPlayer.PlayerGui


end

function Window.Update(Widget: Types.ImGuiWindow, Title: string | Pointer<string>, Open: boolean | Pointer<boolean>, Flags: Types.ImGuiWindowFlags)
    local Window = Widget.Instance

end

return Window
