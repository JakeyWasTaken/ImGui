local Log = {}
Log.LogIndent = 0
Log.LogVerbose = true

function Log.IM_INDENT_LOG()
	Log.LogIndent += 1
end

function Log.IM_UNINDENT_LOG()
	Log.LogIndent -= 1
	Log.LogIndent = math.max(Log.LogIndent, 0)
end

function Log.IM_CORE_ASSERT(condition, callback, ...)
    if not condition or condition == false then
        callback(...)
    end
end

function Log.IM_VERBOSE_ASSERT(condition, callback, ...)
	if not Log.LogVerbose then
		return
	end

	if not condition or condition == false then
        callback(...)
    end
end

function Log.IM_VERBOSE_LOG(message: string)
	if not Log.LogVerbose then
		return
	end

	local Indent = string.rep("    ", Log.LogIndent)

	print(`{Indent}[ImGui][Log]: {message}`)
end

function Log.IM_VERBOSE_WARN(message: string)
	if not Log.LogVerbose then
		return
	end

	local Indent = string.rep("    ", Log.LogIndent)

	warn(`{Indent}[ImGui][Warn]: {message}`)
end

function Log.IM_VERBOSE_ERROR(message: string)
	if not Log.LogVerbose then
		return
	end

	local Indent = string.rep("    ", Log.LogIndent)

	error(`{Indent}[ImGui][Error]: {message}`, 0)
end

function Log.IM_CORE_LOG(message: string)
	local Indent = string.rep("    ", Log.LogIndent)

	print(`{Indent}[ImGui][Log]: {message}`)
end

function Log.IM_CORE_WARN(message: string)
	local Indent = string.rep("    ", Log.LogIndent)

	warn(`{Indent}[ImGui][Warn]: {message}`)
end

function Log.IM_CORE_ERROR(message: string)
	local Indent = string.rep("    ", Log.LogIndent)

	error(`{Indent}[ImGui][Error]: {message}`, 0)
end

return Log
