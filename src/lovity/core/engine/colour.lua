function colour:colour(r, g, b, a)
	self.r = r ~= nil and math.clamp(r, 0, 1) or 1.0
	self.g = g ~= nil and math.clamp(g, 0, 1) or 1.0
	self.b = b ~= nil and math.clamp(b, 0, 1) or 1.0
	self.a = a ~= nil and math.clamp(a, 0, 1) or 1.0

	self.__table = { 0, 0, 0, 0 }

	return self
end

function colour.__add(a,b)
	return setmetatable({
		math.clamp(a[1] + b[1], 0, 1),
		math.clamp(a[2] + b[2], 0, 1),
		math.clamp(a[3] + b[3], 0, 1),
		math.clamp(a[4] + b[4], 0, 1),
		__table = { 0, 0, 0, 0 }
	}, colour)
end

function colour.__sub(a, b)
	return setmetatable({
		math.clamp(a[1] - b[1], 0, 1),
		math.clamp(a[2] - b[2], 0, 1),
		math.clamp(a[3] - b[3], 0, 1),
		math.clamp(a[4] - b[4], 0, 1),
		__table = { 0, 0, 0, 0 }
	}, colour)
end

function colour.__mul(a,b)
	--float * Colour
	if type(a) == "number" then
		return setmetatable({
			math.clamp(a * b[1], 0, 1),
			math.clamp(a * b[2], 0, 1),
			math.clamp(a * b[3], 0, 1),
			math.clamp(a * b[4], 0, 1),
		__table = { 0, 0, 0, 0 }
		}, colour)
	elseif type(b) == "number" then
		return setmetatable({
			math.clamp(a[1] * b, 0, 1),
			math.clamp(a[2] * b, 0, 1),
			math.clamp(a[3] * b, 0, 1),
			math.clamp(a[4] * b, 0, 1),
		__table = { 0, 0, 0, 0 }
		}, colour)
	end

	error("cannot multiply two colours")
end

function colour:set(r, g, b, a)
	self[1] = math.clamp(r or 0.0, 0, 1)
	self[2] = math.clamp(g or 0.0, 0, 1)
	self[3] = math.clamp(b or 0.0, 0, 1)
	self[4] = math.clamp(a or 0.0, 0, 1)
	
	return self
end

function colour.__eq(a, b)
	return a[1] == b[1] and a[2] == b[2] and a[3] == b[3] and a[4] == b[4]
end

function colour.lerp(a, b, t)
	return setmetatable({
			math.clamp(a[1] + (b[1] - a[1]) * t, 0, 1),
			math.clamp(a[2] + (b[2] - a[2]) * t, 0, 1),
			math.clamp(a[3] + (b[3] - a[3]) * t, 0, 1),
			math.clamp(a[4] + (b[4] - a[4]) * t, 0, 1),
			__table = { 0, 0, 0, 0 }
	}, colour)
end