function array:array()
	self.count, self.elements = 0, {}

	return self
end

function array:add(value)
	self.count = self.count + 1; self.elements[self.count] = value
end

function array:get(index)
	if index < 1 or index > self.count then
		return nil
	end

	return self.elements[index]
end

function array:set(index, value)
	if index < 1 or index > self.count - 1 then
		return nil
	end

	self.elements[index] = value
end

function array:size()
	return self.count
end

function array:empty()
	self.count = 0
end