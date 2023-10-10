export type Stack<T> = {
	Push: (self: Stack<T>, T...) -> (),
	Pop: (self: Stack<T>) -> T,
	Peek: (self: Stack<T>) -> T,
	Clear: (self: Stack<T>) -> (),
	IsEmpty: (self: Stack<T>) -> boolean,
	Size: (self: Stack<T>) -> number,
	Iterator: (self: Stack<T>) -> (() -> T),
}

local Stack = {}

function Stack.new<T>(): Stack<T>
	return setmetatable({ data = {}, count = 0 }, { __index = Stack })
end

function Stack:Push(...)
	local numArgs = select("#", ...)
	if numArgs == 0 then
		error("Expected at least one argument", 2)
	end

	for i = 1, numArgs do
		local value = select(i, ...)
		self.count = self.count + 1
		self.data[self.count] = value
	end
end

function Stack:Pop()
	-- If the stack is empty, return nil
	if self.count == 0 then
		return nil
	end

	-- Otherwise, remove the top item from the stack and return it
	local item = self.data[self.count]
	self.data[self.count] = nil
	self.count = self.count - 1
	return item
end

function Stack:Peek()
	-- If the stack is empty, return nil
	if self.count == 0 then
		return nil
	end

	-- Otherwise, return the top item on the stack without removing it
	return self.data[self.count]
end

function Stack:Clear()
	self.data = {}
	self.count = 0
end

function Stack:IsEmpty()
	return self.count == 0
end

function Stack:Size()
	return self.count
end

function Stack:Iterator()
	local index = self.count
	if index == 0 then
		return function() end
	end
	return function()
		if index > 0 then
			local value = self.data[index]
			index = index - 1
			return value
		end
	end
end

function Stack:__tostring()
	local items = {}
	for i = self.count, 1, -1 do
		table.insert(items, tostring(self.data[i]))
	end
	return "Stack [" .. table.concat(items, ", ") .. "]"
end

return Stack
