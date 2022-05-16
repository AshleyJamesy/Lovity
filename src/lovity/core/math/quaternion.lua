local abs = math.abs
local acos = math.acos
local cos = math.cos
local cross = math.cross
local dot = math.dot
local min = math.min
local max = math.max
local normalise = math.normalise
local setmetatable = setmetatable
local sin = math.sin
local sqrt = math.sqrt
local tan = math.tan

function quaternion:quaternion(x, y, z, angle)
	self.x = 0.0
	self.y = 0.0
	self.z = 0.0
	self.w = 1.0

	--self:set(x or 0.0, y or 0.0, z or 0.0, angle or 0.0)

	self.__table = { 0, 0, 0, 0 }

	return self
end

function quaternion.__mul(a, b)
	local ax, ay, az, aw = a.x, a.y, a.z, a.w
	local bx, by, bz, bw = b.x, b.y, b.z, b.w

	return setmetatable({
		x = ax * bw + aw * bx + ay * bz - az * by,
		y = ay * bw + aw * by + az * bx - ax * bz,
		z = az * bw + aw * bz + ax * by - ay * bx,
		w = aw * bw - ax * bx - ay * by - az * by,
		__table = { 0, 0, 0, 0 }
	}, quaternion)
end

function quaternion:getTable()
	local t = self.__table
	
	t[1] = self.x
	t[2] = self.y
	t[3] = self.z
	t[4] = self.w

	return t
end

function quaternion:inverse()
	self.x = -self.x
	self.y = -self.y
	self.z = -self.z
	self.w = self.w

	return self
end

function quaternion:inversed()
	return setmetatable({
		x = -self.x,
		y = -self.y,
		z = -self.z,
		w = self.w,
		__table = { 0, 0, 0, 0 }
	}, quaternion)
end

function quaternion:length()
	local x, y, z, w = self.x, self.y, self.z, self.w
	return sqrt(x * x + y * y + z * z + w * w)
end

function quaternion:normalise()
	local magnitude = self:length()
	local x, y, z, w = self.x, self.y, self.z, self.w

	self.x = abs(x) > 0 and x / magnitude or 0.0
	self.y = abs(y) > 0 and y / magnitude or 0.0
	self.z = abs(z) > 0 and z / magnitude or 0.0
	self.w = abs(w) > 0 and w / magnitude or 0.0

	return self
end

function quaternion:normalised()
	local magnitude = self:length()
	local x, y, z, w = self.x, self.y, self.z, self.w

	return setmetatable({
		x = abs(x) > 0 and x / magnitude or 0.0,
		y = abs(y) > 0 and y / magnitude or 0.0,
		z = abs(z) > 0 and z / magnitude or 0.0,
		w = abs(w) > 0 and w / magnitude or 0.0,
		__table = { 0, 0, 0, 0 }
	}, quaternion)
end

function quaternion:rotate(x, y, z, angle)
	local sH, cH = sin((angle or 0.0) * 0.5), cos((angle or 0.0) * 0.5)
	x, y, z = normalise(x or 0.0, y or 0.0, z or 0.0)

	local ax, ay, az, aw = x * sH, y * sH, z * sH, cH
	local bx, by, bz, bw = self.x, self.y, self.z, self.w

	self.x = ax * bw + aw * bx + ay * bz - az * by
	self.y = ay * bw + aw * by + az * bx - ax * bz
	self.z = az * bw + aw * bz + ax * by - ay * bx
	self.w = aw * bw - ax * bx - ay * by - az * bz

	return self
end

function quaternion:set(x, y, z, angle)
	local sH = sin((angle or 0.0) * 0.5) 
	x, y, z = normalise(x or 0.0, y or 0.0, z or 0.0)

	self.x = x * sH
	self.y = y * sH
	self.z = z * sH
	self.w = cos((angle or 0.0) * 0.5)

	return self
end

function quaternion:toMatrix(matrix)
	self:normalise()

	local x, y, z, w = self.x, self.y, self.z, self.w

	local xx2 = 2 * x * x
	local xy2 = 2 * x * y
	local xz2 = 2 * x * z
	local xw2 = 2 * x * w
	
	local yy2 = 2 * y * y
	local yz2 = 2 * y * z
	local yw2 = 2 * y * w

	local zz2 = 2 * z * z
	local zw2 = 2 * z * w

	matrix[ 1] = 1 - yy2 - zz2
	matrix[ 2] = xy2 - zw2
	matrix[ 3] = xz2 + yw2
	matrix[ 4] = 0.0
	matrix[ 5] = xy2 + zw2
	matrix[ 6] = 1 - xx2 - zz2
	matrix[ 7] = yz2 - xw2
	matrix[ 8] = 0.0
	matrix[ 9] = xz2 - yw2
	matrix[10] = yz2 + xw2
	matrix[11] = 1 - xx2 - yy2
	matrix[12] = 0.0
	matrix[13] = 0.0
	matrix[14] = 0.0
	matrix[15] = 0.0
	matrix[16] = 1.0

	return matrix
end

function quaternion:unpack()
	return self.x, self.y, self.z, self.w
end

function quaternion:tostring(decimals)
	local d = tostring(decimals or 2)

	return string.format(
		"%." .. d .. "f, %." .. d .. "f, %." .. d .. "f, %." .. d .. "f", 
		self.x,
		self.y,
		self.z,
		self.w
	)
end

function quaternion:__tostring()
	return self:tostring(2)
end