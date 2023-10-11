local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ImGui = require(ReplicatedStorage:WaitForChild("ImGui"))

ImGui.Init()

ImGui.OnGui:Connect(function(DeltaTime)
    ImGui.Begin("Test Title", true, {})

    ImGui.End()
end)
