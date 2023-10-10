--!strict

local RunService = game:GetService("RunService")

local Dependencies = script.Dependencies
local Components = script.Components

local Signal = require(Dependencies.Signal)
local Pointer = require(Components.Pointer)
local Stack = require(Components.Stack)
local Types = require(Components.Types)
local Log = require(Components.Log)

type Pointer<T> = Pointer.Pointer<T>
type IdStack = Stack.Stack<Types.ImGuiId>

local function GetPointerValue<T>(Obj: T | Pointer<T>): T
	if Pointer.IsPointer(Obj) then
		return Obj:Get()
	end

	return Obj
end

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
	RunService.RenderStepped:Connect(function(deltaTime)
		ImGui.OnGui:Fire(deltaTime)

	end)
end

function ImGui.PushId(Id: string | number)
	IdStack:push(Id)
end

function ImGui.PopId()
	IdStack:pop()
end

function ImGui.Begin(Title: string | Pointer<string>, Open: boolean?, Flags: Types.ImGuiWindowFlags?)
	local WindowTitle, WindowHash = SeperateHashedText(tostring(GetPointerValue(Title)))
	IM_CORE_ASSERT(WindowTitle, IM_CORE_ERROR, "Expected valid Title to ImGui.Begin()") -- Window name required

	WindowHash = WindowHash == "" and WindowTitle or WindowHash

	IdStack:Push(WindowHash)

	print("Window Id:", IdStackToId(IdStack))
	print("Window Title:", WindowTitle)

	print("ImGuiWindowFlags:", Flags)
end

function ImGui.End()
	-- Somehow have to keep track of endable widgets, otherwise we can call .End() for .PopId() which I dont want to be able to do

	IM_CORE_ASSERT(not IdStack:IsEmpty(), IM_CORE_ERROR, "Too many calls to ImGui.End()") -- Not the correct implementation, TEMP

	IdStack:Pop()
end

ImGui.Pointer = Pointer.new
ImGui.IsPointer = Pointer.IsPointer
ImGui.ImGuiWindowFlags = Types.ImGuiWindowFlags
ImGui.m_Init()
return ImGui
