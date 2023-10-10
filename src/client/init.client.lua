local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ImGui = require(ReplicatedStorage:WaitForChild("ImGui"))

local WindowName = ImGui.Pointer("Window Title")

ImGui.OnGui:Connect(function(DeltaTime)
    ImGui.Begin("Test###0123", {"NoBackground"})

    -- workspace.Name = ExternalWindowName:Get()

    ImGui.End()
end)
