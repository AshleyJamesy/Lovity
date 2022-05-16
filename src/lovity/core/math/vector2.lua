local abs = math.abs
local cos = math.cos
local cross = math.cross
local dot = math.dot
local normalise = math.normalise
local setmetatable = setmetatable
local sin = math.sin
local sqrt = math.sqrt
local tan = math.tan

function vector2:vector2(x, y)
	self.x = x or 0
	self.y = y or 0

	self.__table = { 0, 0 }
end

function vector2.__eq(a, b)
	return a.x == b.x and a.y == b.y
end

function vector2.__add(a, b)
	if type(b) == "number" then
		--vector2 + float
		return setmetatable({ x = a.x + b, y = a.y + b, __table = { 0, 0 } }, vector2)
	elseif type(a) == "number" then
		--float + vector2
		return setmetatable({ x = b.x + a, y = b.y + a, __table = { 0, 0 } }, vector2)
	end

	--vector2 + vector2
	return setmetatable({ x = (a.x or 0) + (b.x or 0), y = (a.y or 0) + (b.y or 0), __table = { 0, 0 } }, vector2)
end

function vector2.__sub(a, b)
	if type(b) == "number" then
		--vector2 - float
		return setmetatable({ x = a.x - b, y = a.y - b, __table = { 0, 0 } }, vector2)
	elseif type(a) == "number" then
		--float - vector2
		return setmetatable({ x = b.x - a, y = b.y - a, __table = { 0, 0 } }, vector2)
	end

	--vector2 - vector2
	return setmetatable({ x = (a.x or 0) - (b.x or 0), y = (a.y or 0) - (b.y or 0), __table = { 0, 0 } }, vector2)
end

function vector2.__mul(a, b)
	if type(b) == "number" then
		--vector2 * float
		return setmetatable({ x = a.x * b, y = a.y * b, __table = { 0, 0 } }, vector2)
	elseif type(a) == "number" then
		--float * vector2
		return setmetatable({ x = b.x * a, y = b.y * a, __table = { 0, 0 } }, vector2)
	end

	--vector2 * vector2
	return setmetatable({ x = a.x * b.x, y = a.y * b.y, __table = { 0, 0 } }, vector2)
end

function vector2:__unm()
	return setmetatable({ x = -self.x, y = -self.y, __table = { 0, 0 } }, vector2)
end

function vector2.cross(a, b)
	return setmetatable({ x = a.y * b.z - a.z * b.y, y = a.z * b.x - a.x * b.z, __table = { 0, 0 } }, vector2)
end

function vector2.dot(a, b)
	return a.x * b.x + a.y * b.y
end

function vector2:getTable()
	local t = self.__table
	
	t[1] = self.x
	t[2] = self.y

	return t
end

function vector2.range(a, b, c)
	return a.x >= b.x and a.x <= c.x and a.y >= b.y and a.y <= c.y
end

function vector2.lerp(a, b, t)
	return a + (b - a) * t
end

function vector2:magnitude()
	return abs(sqrt(self.x * self.x + self.y * self.y))
end

function vector2:normalise()
	local magnitude = self:magnitude()

	self.x = abs(self.x) > 0 and (self.x / magnitude) or 0
	self.y = abs(self.y) > 0 and (self.y / magnitude) or 0

	return self
end

function vector2:normalised()
	local magnitude = self:magnitude()

	return setmetatable({
		x = abs(self.x) > 0 and self.x / magnitude or 0, 
		y = abs(self.y) > 0 and self.y / magnitude or 0,
		__table = { 0, 0 }
	}, vector2)
end

function vector2:set(x, y)
	self.x = x or 0
	self.y = y or 0
end

function vector2:sum()
	return self.x + self.y
end

function vector2:tostring(decimals)
	local d = tostring(decimals or 2)
	return string.format("%." .. d .. "f, %." .. d .. "f", self.x, self.y)
end

function vector2:__tostring()
	return self:tostring(2)
end

function vector2:unpack()
	return self.x, self.y
end