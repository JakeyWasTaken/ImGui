export type Pointer<T> = {
    Set: (self: Pointer<T>, Value: T?) -> (),
    Get: (self: Pointer<T>) -> T?,
    Duplicate: (self: Pointer<T>) -> Pointer<T>,
    Destroy: (self: Pointer<T>) -> ()
}

local Root = {}

local Pointer = {}
Pointer.__index = Pointer
Pointer.__type = "ImGuiPointer"
Pointer.__tostring = function(self)
    return `&({tostring(self.Value)}) ImGuiPointer`
end

function Pointer:Set(Value: any?)
	self.Value = Value
end

function Pointer:Get()
	local Value = self.Value
	return Value
end

function Pointer:Duplicate()
	return Root.new(self.Value)
end

function Root.new<T>(Value: any?) : Pointer<T>
    local self = setmetatable({}, Pointer)

    self.Value = Value

    return self
end

function Root.IsPointer(Obj: any): boolean
    if not Obj then
        return false
    end

    if type(Obj) ~= "table" then
        return false
    end

    if getmetatable(Obj) == Pointer then
        return true
    end

    return false
end

return Root
