local RunService = game:GetService("RunService")

local Components = script.Components
local Widgets = script.Widgets

local Signal = require(Components.Signal)
local Pointer = require(Components.Pointer)
local Stack = require(Components.Stack)
local Types = require(Components.Types)
local Log = require(Components.Log)
local Style = require(Components.Style)
local Internal = require(Components.Internal)

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

local function Reconcile<S, T>(src: S, template: T): S & T
	assert(type(src) == "table", "First argument must be a table")
	assert(type(template) == "table", "Second argument must be a table")

	local tbl = table.clone(src)

	for k, v in template do
		local sv = src[k]
		if sv == nil then
			if type(v) == "table" then
				tbl[k] = deepCopy(v)
			else
				tbl[k] = v
			end
		elseif type(sv) == "table" then
			if type(v) == "table" then
				tbl[k] = Reconcile(sv, v)
			else
				tbl[k] = deepCopy(sv)
			end
		end
	end

	return (tbl :: any) :: S & T
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

function ImGui.Init(Parent: BasePlayerGui?)
	if not Parent then
		Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	end

	Internal.RenderTarget = Parent
	Internal.IdStack = IdStack

	ImGui.SetStyle() -- Set style to default

	Internal.GenerateSelectionImageObject()

	RunService.RenderStepped:Connect(function(deltaTime)
		Internal.CycleId += 1
		ImGui.OnGui:Fire(deltaTime)

		IM_CORE_ASSERT(IdStack:IsEmpty(), IM_CORE_ERROR, "You've forgotten to end a widget! IdStack isn't empty!")

		Internal.Context.LastDOM = deepCopy(Internal.Context.DOM)
		Internal.Context.DOM = {}
	end)
end

function ImGui.PushId(Id: Types.ImGuiId)
	IM_CORE_ASSERT(type(Id) == string and Id, IM_CORE_ERROR, "ImGui.PushId() expects an id of type string")
	IM_CORE_ASSERT(Internal.Context.ActiveWindow, IM_CORE_ERROR, "ImGui.PushId() cannot be called before a window is created, if you wish to set the id of a window then format the window title as Title###Id")
	IdStack:Push(Id)
end

function ImGui.PopId()
	IdStack:Pop()
end

function ImGui.GetStyle(): Types.Style
	return Internal.Context.ActiveStyle
end

function ImGui.SetStyle(Input: Types.Style?)
	Input = Input or {}

	IM_CORE_ASSERT(type(Input) == "table", IM_CORE_ERROR, "Expected type Input to ImGui.SetStyle() to be a table")

	-- Bad implementation but it works
	local NewStyle = {}

	local DefaultDark = Style.colorDark
	local SizeDefault = Style.sizeDefault
	local Utility = Style.utilityDefault
	local Icons = Style.icons

	NewStyle = Reconcile(Input, DefaultDark)
	NewStyle = Reconcile(NewStyle, SizeDefault)
	NewStyle = Reconcile(NewStyle, Utility)
	NewStyle = Reconcile(NewStyle, Icons)

	IM_VERBOSE_LOG("New Style", NewStyle)

	Internal.Context.ActiveStyle = NewStyle
	Internal.Context.RefreshStyle = true
end

-- Title can take in Window###0123 for a Uid this way only Window will be displayed as the title and only ###0123 will be used as the id.
function ImGui.Begin(p_Title: string | Pointer<string>, p_Open: boolean | Pointer<boolean>, Flags: Types.ImGuiWindowFlags)
	local Title = tostring(GetPointerValue(p_Title))
	local Open = GetPointerValue(p_Open)

	IM_CORE_ASSERT(Title ~= nil and #Title ~= 0, IM_CORE_ERROR, "ImGui.Begin() expects a valid title") -- Window name required
	IM_CORE_ASSERT(Open ~= nil and type(Open) == "boolean", IM_CORE_ERROR, "ImGui.Begin() expects value of p_Open to be of type boolean.") -- p_Open required of type boolean
	IM_CORE_ASSERT(Flags ~= nil and type(Flags) == "table", IM_CORE_ERROR, "ImGui.Begin() expects valid window flags")
	IM_CORE_ASSERT(IdStack:IsEmpty(), IM_CORE_ERROR, "ImGui.Begin() should be called before anything else.")

	local WindowTitle, WindowHash = SeperateHashedText(Title)

	WindowHash = WindowHash == "" and WindowTitle or WindowHash -- If WindowHash == "" set it to WindowTitle
	Flags = Flags or {}

	IdStack:Push(WindowHash)

	local WindowId = IdStackToId(IdStack)

	local g = Internal.Context

	local WidgetData : Types.ImGuiWindow = g.LastDOM[WindowId]

	if WidgetData then
		IM_CORE_ASSERT(WidgetData.Type == "Window", IM_CORE_WARN, `ImGui.Begin() Conflict error, the id {WindowId} belongs to another widget of type {WidgetData.Type}`)

		if Internal.CycleId - WidgetData.State.CreationCycle == 1 then -- Hide window for 1 frame to determine the size
			Window.DetermineWindowSize(WidgetData)
		else
			Window.UpdateState(WidgetData)
			Window.Update(WidgetData, Title, Open, Flags)
		end
	else
		WidgetData = {
			ZIndex = 0x40,
			Id = WindowId,
			Type = "Window",
			State = {
				CreationCycle = Internal.CycleId,
			},
		}

		WidgetData.Instance = Window.Generate(WidgetData)
	end

	g.DOM[WindowId] = WidgetData
	g.ActiveWindow = WidgetData
end

function ImGui.End()
	IM_CORE_ASSERT(Internal.Context.ActiveWindow, IM_CORE_ERROR, "Cannot call ImGui.End() if there is no active Window")

	Internal.Context.ActiveWindow = nil

	IdStack:Pop()
end

ImGui.Pointer = Pointer.new
ImGui.IsPointer = Pointer.IsPointer
ImGui.ImGuiWindowFlags = Types.ImGuiWindowFlags
return ImGui
