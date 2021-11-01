class.name = "engine.colour"

function class:init(r, g, b, a)
	r = r or 1.0
	g = g or 1.0
	b = b or 1.0
	a = a or 1.0

	return setmetatable({ 
		math.clamp(r, 0, 1),
		math.clamp(g, 0, 1),
		math.clamp(b, 0, 1),
		math.clamp(a, 0, 1)
	}, class)
end

function class:colour()
end

function class.__add(a,b)
	return setmetatable({
		math.clamp(a[1] + b[1], 0, 1),
		math.clamp(a[2] + b[2], 0, 1),
		math.clamp(a[3] + b[3], 0, 1),
		math.clamp(a[4] + b[4], 0, 1)
	}, class)
end

function class.__sub(a, b)
	return setmetatable({
		math.clamp(a[1] - b[1], 0, 1),
		math.clamp(a[2] - b[2], 0, 1),
		math.clamp(a[3] - b[3], 0, 1),
		math.clamp(a[4] - b[4], 0, 1)
	}, class)
end

function class.__mul(a,b)
	--float * Colour
	if type(a) == "number" then
		return setmetatable({
			math.clamp(a * b[1], 0, 1),
			math.clamp(a * b[2], 0, 1),
			math.clamp(a * b[3], 0, 1),
			math.clamp(a * b[4], 0, 1)
		}, class)
	elseif type(b) == "number" then
		return setmetatable({
			math.clamp(a[1] * b, 0, 1),
			math.clamp(a[2] * b, 0, 1),
			math.clamp(a[3] * b, 0, 1),
			math.clamp(a[4] * b, 0, 1)
		}, class)
	end

	error("cannot multiply two colours")
end

function class:set(r, g, b, a)
	self[1] = math.clamp(r, 0, 1)
	self[2] = math.clamp(g, 0, 1)
	self[3] = math.clamp(b, 0, 1)
	self[4] = math.clamp(a, 0, 1)
	
	return self
end

function class.__eq(a, b)
	return a[1] == b[1] and a[2] == b[2] and a[3] == b[3] and a[4] == b[4]
end

function class.lerp(a, b, t)
	return setmetatable({
			math.clamp(a[1] + (b[1] - a[1]) * t, 0, 1),
			math.clamp(a[2] + (b[2] - a[2]) * t, 0, 1),
			math.clamp(a[3] + (b[3] - a[3]) * t, 0, 1),
			math.clamp(a[4] + (b[4] - a[4]) * t, 0, 1)
	}, class)
end