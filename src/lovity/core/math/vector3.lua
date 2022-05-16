local abs = math.abs
local cos = math.cos
local sin = math.sin
local cross = math.cross
local dot = math.dot
local normalise = math.normalise
local sqrt = math.sqrt
local tan = math.tan
local setmetatable = setmetatable

function vector3:vector3(x, y, z)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
	
	self.__table = { 0, 0, 0 }

	return self
end

function vector3.__eq(a, b)
	return a.x == b.x and a.y == b.y and a.z == b.z
end

function vector3.__add(a, b)
	if type(b) == "number" then
		--vector3 + float
		return setmetatable({ x = a.x + b, y = a.y + b, z = a.z + b, __table = { 0, 0, 0 } }, vector3)
	elseif type(a) == "number" then
		--float + vector3
		return setmetatable({ x = b.x + a, y = b.y + a, z = b.z + a, __table = { 0, 0, 0 } }, vector3)
	end

	--vector3 + vector3
	return setmetatable({ x = (a.x or 0) + (b.x or 0), y = (a.y or 0) + (b.y or 0), z = (a.z or 0) + (b.z or 0), __table = { 0, 0, 0 } }, vector3)
end

function vector3.__sub(a, b)
	if type(b) == "number" then
		--vector3 - float
		return setmetatable({ x = a.x - b, y = a.y - b, z = a.z - b, __table = { 0, 0, 0 } }, vector3)
	elseif type(a) == "number" then
		--float - vector3
		return setmetatable({ x = b.x - a, y = b.y - a, z = b.z - a, __table = { 0, 0, 0 } }, vector3)
	end

	--vector3 - vector3
	return setmetatable({ x = (a.x or 0) - (b.x or 0), y = (a.y or 0) - (b.y or 0), z = (a.z or 0) - (b.z or 0), __table = { 0, 0, 0 } }, vector3)
end

function vector3.__mul(a, b)
	if type(b) == "number" then
		--vector3 * float
		return setmetatable({ x = a.x * b, y = a.y * b, z = a.z * b, __table = { 0, 0, 0 } }, vector3)
	elseif type(a) == "number" then
		--float * vector3
		return setmetatable({ x = b.x * a, y = b.y * a, z = b.z * a, __table = { 0, 0, 0 } }, vector3)
	end

	--vector3 * vector3
	return setmetatable({ x = a.x * b.x, y = a.y * b.y, z = a.z * b.z, __table = { 0, 0, 0 } }, vector3)
end

function vector3:__unm()
	return setmetatable({ x = -self.x, y = -self.y, z = self.z, __table = { 0, 0, 0 } }, vector3)
end

function vector3:set(x, y, z)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
end

function vector3:sum()
	return self.x + self.y + self.z
end

function vector3:magnitude()
	return math.abs(math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z))
end

function vector3.cross(a, b)
	return setmetatable({
		x = a.y * b.z - a.z * b.y,
		y = a.z * b.x - a.x * b.z,
		z = a.x * b.y - a.y * b.x
	}, vector3)
end

function vector3:normalise()
	local magnitude = self:magnitude()

	self.x = math.abs(self.x) > 0 and (self.x / magnitude) or 0
	self.y = math.abs(self.y) > 0 and (self.y / magnitude) or 0
	self.z = math.abs(self.z) > 0 and (self.z / magnitude) or 0
end

function vector3:normalised()
	local magnitude = self:magnitude()

	return setmetatable({
		x = math.abs(self.x) > 0 and self.x / magnitude or 0,
		y = math.abs(self.y) > 0 and self.y / magnitude or 0,
		z = math.abs(self.z) > 0 and self.z / magnitude or 0,
		__table = { 0, 0, 0 }
	}, vector3)
end

function vector3.dot(a, b)
	return a.x * b.x + a.y * b.y + a.z * b.z
end

function vector3.range(a, b, c)
	return a.x >= b.x and a.x <= c.x and a.y >= b.y and a.y <= c.y and a.z >= b.z and a.z <= c.z
end

function vector3.lerp(a, b, t)
	return a + (b - a) * t
end

function vector3:unpack()
	return self.x, self.y, self.z
end

function vector3:tostring(decimals)
	local format = "%." .. tostring(decimals or 2) .. "f"
	return string.format(format .. ", " .. format .. ", " .. format, self.x, self.y, self.z)
end

function  vector3.__tostring(self)
	return self:tostring()
end

function vector3:getTable()
	local t = self.__table
	
	t[1] = self.x
	t[2] = self.y
	t[3] = self.z

	return t
end