class.name = "math.vector3"

function class:vector3(x, y, z)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
	
	self.__table = { 0, 0, 0 }
end

--OPERATIONS
function class.__eq(a, b)
	return a.x == b.x and a.y == b.y and a.z == b.z
end

function class.__add(a, b)
	if type(b) == "number" then
		--vector3 + float
		return setmetatable({ x = a.x + b, y = a.y + b, z = a.z + b }, class)
	elseif type(a) == "number" then
		--float + vector3
		return setmetatable({ x = b.x + a, y = b.y + a, z = b.z + a }, class)
	end

	--vector3 + vector3
	return setmetatable({ x = (a.x or 0) + (b.x or 0), y = (a.y or 0) + (b.y or 0), z = (a.z or 0) + (b.z or 0) }, class)
end

function class.__sub(a, b)
	if type(b) == "number" then
		--vector3 - float
		return setmetatable({ x = a.x - b, y = a.y - b, z = a.z - b }, class)
	elseif type(a) == "number" then
		--float - vector3
		return setmetatable({ x = b.x - a, y = b.y - a, z = b.z - a }, class)
	end

	--vector3 - vector3
	return setmetatable({ x = (a.x or 0) - (b.x or 0), y = (a.y or 0) - (b.y or 0), z = (a.z or 0) - (b.z or 0) }, class)
end

function class.__mul(a, b)
	if type(b) == "number" then
		--vector3 * float
		return setmetatable({ x = a.x * b, y = a.y * b, z = a.z * b }, class)
	elseif type(a) == "number" then
		--float * vector3
		return setmetatable({ x = b.x * a, y = b.y * a, z = b.z * a }, class)
	end

	--vector3 * vector3
	return setmetatable({ x = a.x * b.x, y = a.y * b.y, z = a.z * b.z }, class)
end

function class:__unm()
	return setmetatable({ x = -self.x, y = -self.y, z = self.z }, class)
end

--GENERAL FUNCTIONS
function class:set(x, y, z)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
end

function class:sum()
	return self.x + self.y + self.z
end

function class:magnitude()
	return math.abs(math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z))
end

function class:normalised()
	local magnitude = self:magnitude()

	return setmetatable({
		x = math.abs(self.x) > 0 and self.x / magnitude or 0, 
		y = math.abs(self.y) > 0 and self.y / magnitude or 0,
		z = math.abs(self.z) > 0 and self.z / magnitude or 0
	}, class)
end

function class.cross(a, b)
	return setmetatable({
		x = a.y * b.z - a.z * b.y,
		y = a.z * b.x - a.x * b.z,
		z = a.x * b.y - a.y * b.x
	}, class)
end

function class:normalise()
	local magnitude = self:magnitude()

	self.x = math.abs(self.x) > 0 and (self.x / magnitude) or 0
	self.y = math.abs(self.y) > 0 and (self.y / magnitude) or 0
	self.z = math.abs(self.z) > 0 and (self.z / magnitude) or 0
end

function class.dot(a, b)
	return a.x * b.x + a.y * b.y + a.z * b.z
end

function class.range(a, b, c)
	return a.x >= b.x and a.x <= c.x and a.y >= b.y and a.y <= c.y and a.z >= b.z and a.z <= c.z
end

function class.lerp(a, b, t)
	return a + (b - a) * t
end

function class:unpack()
	return self.x, self.y, self.z
end

function class:tostring(decimals)
	local format = "%." .. tostring(decimals or 2) .. "f"
	return string.format(format .. ", " .. format .. ", " .. format, self.x, self.y, self.z)
end

function  class.__tostring(self)
	return self:tostring()
end

function class:getTable()
	local t = self.__table
	
	t[1] = self.x
	t[2] = self.y
	t[3] = self.z

	return t
end