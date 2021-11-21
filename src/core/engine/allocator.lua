class.name = "engine.allocator"

function class:allocator()
	self.free = {}
	self.used = {}
end

function class:add(id)
	local free, used = self.free, self.used

	for i = 1, #free do
		if id == free[i] then
			return
		end
	end

	for i = 1, #used do
		if id == used[i] then
			return
		end
	end

	table.insert(used, id)

	return id
end

function class:count()
	return #self.free + #self.used 
end

function class:get()
	local id

	if #self.free > 0 then
		id = table.remove(self.free, 1)
	end

	return id
end

function class:clear()
	for i = 1, #used do
		table.insert(free, table.remove(used, 1))
	end
end

function class:remove(id)
	local used = self.used

	for i = #used, 1, -1 do
		if used[i] == id then
			table.remove(used, i)
			return true
		end
	end

	return false
end