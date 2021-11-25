--[[
- @module math.quaternion
- @brief a quaternion class
]]
class.name = "math.quaternion"

local abs 	= math.abs
local acos 	= math.acos
local cos 	= math.cos
local sin 	= math.sin
local min 	= math.min
local max 	= math.max
local sqrt 	= math.sqrt

--[[
- @brief returns a new quaternion
- @param x:`number`
- @param y:`number`
- @param z:`number`
- @param w:`number`
- @return `math.quaternion`
]]
function class:quaternion(x, y, z, w)
	self.x = x or 0.0
	self.y = y or 0.0
	self.z = z or 0.0
	self.w = w or 0.0
end

function class:length()
	local x, y, z, w = self.x, self.y, self.z, self.w
	return sqrt(x * x + y * y + z * z + w * w)
end

--[[
- @brief normalises the quaternion
- @return `math.quaternion` self
]]
function class:normalise()
	local magnitude = self:length()
	local x, y, z, w = self.x, self.y, self.z, self.w

	self.x = abs(x) > 0 and x / magnitude or 0.0
	self.y = abs(y) > 0 and y / magnitude or 0.0
	self.z = abs(z) > 0 and z / magnitude or 0.0
	self.w = abs(w) > 0 and w / magnitude or 0.0

	return self
end

function class:conjugate()
	self.x = -self.x
	self.y = -self.y
	self.z = -self.z
	self.w =  self.w
end

function class:conjugated()
	return setmetatable({
		x = -self.x,
		y = -self.y,
		z = -self.z,
		w =  self.w
	}, class)
end

function class:rotate(x, y, z, angle)
	local sH = math.sin(angle * 0.5)
	local cH = math.cos(angle * 0.5)

	local ax, ay, az, aw = x * sH, y * sH, z * sH, cH
	local bx, by, bz, bw = self.x, self.y, self.z, self.w

	self.x = ax * bw + aw * bx + ay * bz - az * by
	self.y = ay * bw + aw * by + az * bx - ax * bz
	self.z = az * bw + aw * bz + ax * by - ay * bx
	self.w = aw * bw - ax * bx - ay * by - az * bz

	return self
end

function class.__mul(a, b)
	local ax, ay, az, aw = a.x, a.y, a.z, a.w
	local bx, by, bz, bw = b.x, b.y, b.z, b.w

	return setmetatable({
		x = ax * bw + aw * bx + ay * bz - az * by,
		y = ay * bw + aw * by + az * bx - ax * bz,
		z = az * bw + aw * bz + ax * by - ay * bx,
		w = aw * bw - ax * bx - ay * by - az * by
	}, class)
end

function class:toMatrix(matrix)
	self:normalise()

	local x, y, z, w = self.x, self.y, self.z, self.w

	matrix[ 1] = 1 - 2 * y ^ 2 - 2 * z ^ 2  
	matrix[ 2] = 2 * x * y - 2 * z * w
	matrix[ 3] = 2 * x * z + 2 * y * w
	matrix[ 4] = 0.0
	matrix[ 5] = 2 * x * y + 2 * z * w
	matrix[ 6] = 1 - 2 * x ^ 2 - 2 * z ^ 2
	matrix[ 7] = 2 * y * z - 2 * x * w
	matrix[ 8] = 0.0
	matrix[ 9] = 2 * x * z - 2 * y * w 
	matrix[10] = 2 * y * z + 2 * x * w
	matrix[11] = 1 - 2 * x ^ 2 - 2 * y ^ 2
	matrix[12] = 0.0
	matrix[13] = 0.0
	matrix[14] = 0.0
	matrix[15] = 0.0
	matrix[16] = 1.0

	return matrix
end

function class:inverse()
	self.x = -self.x
	self.y = -self.y
	self.z = -self.z
	self.w = self.w

	return self
end

--[[
- @brief returns a copy of the quaternion
- @return `math.quaternion` new quaternion
]]
function class:clone()
	return setmetatable({ unpack(self) }, class)
end

--[[
- @brief returns a string of the quaternion
- @param decimals:`number` the number of decimals to display, default is 2
- @return `string` "0.00, 0.00, 0.00, 1.00"
]]
function class:tostring(decimals)
	local d = tostring(decimals or 2)

	return string.format(
		"%." .. d .. "f, %." .. d .. "f, %." .. d .. "f, %." .. d .. "f", 
		self.x,
		self.y,
		self.z,
		self.w
	)
end

--[[
- @brief returns a string of the quaternion for tostring(`math.quaternion`)
- @return `string` "0.00, 0.00, 0.00, 1.00" to 2 decimal places
]]
function class:__tostring()
	return self:tostring(2)
end