local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ImGui = require(ReplicatedStorage:WaitForChild("ImGui"))

ImGui.OnGui:Connect(function(DeltaTime)
    ImGui.Begin("Test Title")

    ImGui.End()
end)
