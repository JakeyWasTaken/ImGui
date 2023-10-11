local RunService = game:GetService("RunService")

local Components = script.Components
local Widgets = script.Widgets

local Signal = require(Components.Signal)
local Pointer = require(Components.Pointer)
local Stack = require(Components.Stack)
local Types = require(Components.Types)
local Log = require(Components.Log)
local Internal: Types.Internal = require(Components.Internal)

local Window = require(Widgets.Window)

type Pointer<T> = Pointer.Pointer<T>
type IdStack = Stack.Stack<Types.ImGuiId>

-- Returns the value of Obj, if Obj is a pointer it calls Obj:Get() else return Obj
local function GetPointerValue<T>(Obj: T | Pointer<T>): T
	if Pointer.IsPointer(Obj) then
		return Obj:Get()
	end

	return Obj
end

 -- Should be used as PossiblePointer = SetPointerValue(PossiblePointer, DataType)
local function SetPointerValue<T>(Obj: T | Pointer<T>, Value: any?)
	if Pointer.IsPointer(Obj) then
		Obj:Set(Value)

		return Obj
	end

	return Value
end

-- Returns the title with seperated hash, this is to support the same naming scheme as DearImGui
-- SeperateHashedText("Test###0123") will return a tuple of ("Test", "###0123")
local function SeperateHashedText(Data: string): (string, string)
	local Chars = ""
	local HashStart = -1

	for i = 1, #Data do
		local Next = Data:sub(i, i + 2)

		if Next == "###" then
			HashStart = i
			Chars = Data:sub(i, #Data)
			break
		end
	end

	if HashStart ~= -1 then
		return Data:sub(1, HashStart - 1), Chars
	end

	return Data, ""
end

local function IdStackToId(Stack: IdStack)
	return table.concat(Stack.data, "::")
end

local function deepCopy<T>(original: T): T
	local copy = {}

	for k, v in pairs(original) do
		if type(v) == "table" then
			v = deepCopy(v)
		end
		copy[k] = v
	end

	return copy
end

local OnGui: Signal.Signal<number> = Signal.new()
local IdStack: IdStack = Stack.new()
local IM_INDENT_LOG = Log.IM_INDENT_LOG
local IM_UNINDENT_LOG = Log.IM_UNINDENT_LOG
local IM_VERBOSE_ASSERT = Log.IM_VERBOSE_ASSERT
local IM_VERBOSE_LOG = Log.IM_VERBOSE_LOG
local IM_VERBOSE_WARN = Log.IM_VERBOSE_WARN
local IM_VERBOSE_ERROR = Log.IM_VERBOSE_ERROR
local IM_CORE_ASSERT = Log.IM_CORE_ASSERT
local IM_CORE_LOG = Log.IM_CORE_LOG
local IM_CORE_WARN = Log.IM_CORE_WARN
local IM_CORE_ERROR = Log.IM_CORE_ERROR

local ImGui = {}
ImGui.OnGui = OnGui

function ImGui.m_Init()
	Internal.DOM = {}
	Internal.LastDOM = {}
	Internal.IdStack = IdStack
	Internal.ActiveWindow = nil

	RunService.RenderStepped:Connect(function(deltaTime)
		ImGui.OnGui:Fire(deltaTime)

		IM_CORE_ASSERT(IdStack:IsEmpty(), IM_CORE_ERROR, "You've forgotten to end a widget! IdStack isn't empty!")

		Internal.LastDOM = deepCopy(Internal.DOM)
		Internal.DOM = {}
	end)
end

function ImGui.PushId(Id: Types.ImGuiId)
	IdStack:Push(Id)
end

function ImGui.PopId()
	IdStack:Pop()
end

function ImGui.Begin(Title: string | Pointer<string>, Open: boolean | Pointer<boolean>?, Flags: Types.ImGuiWindowFlags?)
	local WindowTitle, WindowHash = SeperateHashedText(tostring(GetPointerValue(Title)))
	IM_CORE_ASSERT(WindowTitle ~= nil or #WindowTitle ~= 0, IM_CORE_ERROR, "Expected valid Title to ImGui.Begin()") -- Window name required

	WindowHash = WindowHash == "" and WindowTitle or WindowHash -- If WindowHash == "" set it to WindowTitle
	Flags = Flags or {}

	IdStack:Push(WindowHash)

	local WindowId = IdStackToId(IdStack)

	local WidgetData : Types.ImGuiWindow = Internal.LastDOM[WindowId]

	if WidgetData then
		Window.Update(WidgetData)
	else
		WidgetData = {
			Id = WindowId,
			Instance = Window.Generate(WidgetData)
		}
	end

	Internal.DOM[WindowId] = WidgetData
	Internal.ActiveWindow = WidgetData
end

function ImGui.End()
	IM_CORE_ASSERT(Internal.ActiveWindow, IM_CORE_ERROR, "Cannot call ImGui.End() if there is no active Window")

	Internal.ActiveWindow = nil

	IdStack:Pop()
end

ImGui.Pointer = Pointer.new
ImGui.IsPointer = Pointer.IsPointer
ImGui.ImGuiWindowFlags = Types.ImGuiWindowFlags
ImGui.m_Init()
return ImGui
