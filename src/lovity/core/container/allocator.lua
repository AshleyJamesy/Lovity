local insert = table.insert
local search = table.search
local sort = table.sort
local remove = table.remove

function allocator:allocator()
	self.free = {}
	self.used = {}

	return self
end

function allocator:get()
	local id = #self.free > 0 and self.free[1] or (#self.used > 0 and (self.used[#self.used] + 1) or 1)

	local _, k = search(self.used, id)
	insert(self.used, k + 1, id)

	return id
end

function allocator:clear()
	local free, used = self.free, self.used

	for i = 1, #used do
		insert(free, remove(used, 1))
	end

	sort(free)
end

function allocator:copy()
	return setmetatable(table.copy(self), allocator)
end

function allocator:count()
	return #self.free + #self.used 
end

function allocator:remove(id)
	local _id, k = search(self.used, id)
	if _id ~= nil then
		remove(self.used, k)
	end

	local _, k = search(self.free, _id)
	insert(self.free, k + 1, _id)
end

