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
	local x, y, z, w = self.x, self.y, self.z, self.w
	local magnitude = self:length()

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

--[[
- @brief converts quaternion to matrix
- @param matrix:`math.matrix` the matrix to store the results in
- @return `math.matrix` resulting matrix provided from first argument
]]
function class:toMatrix(matrix)
	self:normalise()

	local x, y, z, w = self.x, self.y, self.z, self.w
	local xy = x * y
	local xz = x * z
	local xw = x * w
	local yz = y * z
	local yw = y * w
	local zw = z * w
	local xs = x * x
	local ys = y * y
	local zs = z * z

	matrix[ 1] = 1 - 2 * (ys + zs)
	matrix[ 2] = 2 * (xy - zw)
	matrix[ 3] = 2 * (xz + yw)
	matrix[ 4] = 0.0
	matrix[ 5] = 2 * (xy + zw)
	matrix[ 6] = 1 - 2 * (xs + zs)
	matrix[ 7] = 2 * (yz - xw)
	matrix[ 8] = 0.0
	matrix[ 9] = 2 * (xz - yw)
	matrix[10] = 2 * (yz + xw)
	matrix[11] = 1 - 2 * (xs + ys)
	matrix[12] = 0.0
	matrix[13] = 0.0
	matrix[14] = 0.0
	matrix[15] = 0.0
	matrix[16] = 1.0

	return matrix
end

--[[
- @brief converts matrix to quaternion and stores the results in this quaternion
- @param matrix:`math.matrix` the matrix to convert to `math.quaternion`
- @return `math.quaternion` self
]]
function class:fromMatrix(matrix)
	local m11, m12, m13, m21, m22, m23, m31, m32, m33 = 
		matrix[ 1], matrix[ 2], matrix[ 3],
		matrix[ 5], matrix[ 6], matrix[ 7],
		matrix[ 9], matrix[10], matrix[11]

	local d = m11 + m22 + m33

	if d > 0 then
		local w4 = sqrt(d + 1) * 2
		self.x = (m32 - m23) / w4
		self.y = (m13 - m31) / w4
		self.z = (m21 - m12) / w4
		self.w = w4 / 4
	elseif m11 > m22 and m11 > m33 then
		local x4 = sqrt(1 + m11 - m22 - m33) * 2
		self.x = x4 / 4
		self.y = (m12 + m21) / x4
		self.z = (m13 + m31) / x4
		self.w = (m32 - m23) / x4
	elseif m22 > m33 then
		local y4 = sqrt(1 + m22 - m11 - m33) * 2
		self.x = (m12 + m21) / y4
		self.y = y4 / 4
		self.z = (m23 + m32) / y4
		self.w = (m13 - m31) / y4
	else
		local z4 = sqrt(1 + m33 - m11 - m22) * 2
		self.x = (m13 + m31) / z4
		self.y = (m23 + m32) / z4
		self.z = y4 / 4
		self.w = (m21 - m12) / z4
	end

	return self
end

function class:setEuler(x, y, z)
	local sinX = sin(x)
    local cosX = cos(x)
    local sinY = sin(y)
    local cosY = cos(y)
    local sinZ = sin(z)
    local cosZ = cos(z)

    self.w = cosY * cosX * cosZ + sinY * sinX * sinZ
    self.x = cosY * sinX * cosZ + sinY * cosX * sinZ
    self.y = sinY * cosX * cosZ - cosY * sinX * sinZ
    self.z = cosY * cosX * sinZ - sinY * sinX * cosZ

    return self
end

local asin = math.asin
local atan2 = math.atan2
local rad2Deg = 180 / math.pi

local PI = math.pi
local PI_HALF = PI * 0.5
local PI_TWO = 2 * PI
local FLIP_n = -0.0001
local FLIP_p = PI_TWO - 0.0001

local function sanitize(x, y, z)
	return
		x < FLIP_n and x + PI_TWO or (x > FLIP_p and x + PI_TWO or x),
		y < FLIP_n and y + PI_TWO or (y > FLIP_p and y + PI_TWO or y),
		z < FLIP_n and z + PI_TWO or (z > FLIP_p and z + PI_TWO or z)
end

function class:getEulerAngles()
	local x, y, z, w, ex, ey, ez = self.x, self.y, self.z, self.w
	local bias = 2 * (y * z - w * x)

	if bias < 0.999 then
		if bias > -0.999 then
			ex, ey, ez = sanitize(
				-asin(bias),
				atan2(2 * (x * z + w * y), 1 - 2 * (x * x + y * y)),
				atan2(2 * (x * y + w * z), 1 - 2 * (x * x + z * z))
			)
		else
			ex, ey, ez = sanitize(
				PI_HALF,
				atan2(2 * (x * y - w * z), 1 - 2 * (y * y + z * z)),
				0.0
			)
		end
	else
		ex, ey, ez = sanitize(
			-PI_HALF,
			atan2(-2 * (x * y - w * z), 1 - 2 * (y * y + z * z)),
			0.0
		)
	end

	return ex, ey, ez
end

function class:rotate(x, y, z)
	local sinX = sin(x)
    local cosX = cos(x)
    local sinY = sin(y)
    local cosY = cos(y)
    local sinZ = sin(z)
    local cosZ = cos(z)

	local aw, ax, ay, az = self.x, self.y, self.z, self.w
	local bx, by, bz, bw =
		cosY * cosX * cosZ + sinY * sinX * sinZ,
		cosY * sinX * cosZ + sinY * cosX * sinZ,
		sinY * cosX * cosZ - cosY * sinX * sinZ,
		cosY * cosX * sinZ - sinY * sinX * cosZ

	self.x = (((aw * bx) + (ax * bw)) + (ay * bz)) - (az * by)
	self.y = (((aw * by) + (ay * bw)) + (az * bx)) - (ax * bz)
	self.z = (((aw * bz) + (az * bw)) + (ax * by)) - (ay * bx)
	self.w = (((aw * bw) - (ax * bx)) - (ay * by)) - (az * bz)

	return self
end

function class:inverse()
	self.x = -self.x
	self.y = -self.y
	self.z = -self.z
	self.w = self.w

	return self
end

--[[
- @brief interpolate between 2 quaternions given t value
- @param a:`math.quaternion` the quaternion to interpolate from
- @param b:`math.quaternion` the quaternion to interpolate to
- @param t:`number`
- @return `math.quaternion` new quaternion
]]
function class.interpolate(a, b, t)
	local rx, ry, rz, rw = 0.0, 0.0, 0.0, 1.0

	local ax, ay, az, aw = a.x, a.y, a.z, a.w
	local bx, by, bz, bw = b.x, b.y, b.z, b.w

	local dot = aw * bw + ax * bx + ay * by + az * bz
	local ta = 1.0 - t

	if dot < 0.0 then
		return setmetatable(
			ta * ax + t * -bx,
			ta * ay + t * -by,
			ta * az + t * -bz,
			ta * aw + t * -bw
		, class):normalise()
	else
		return setmetatable(
			ta * ax + t * bx,
			ta * ay + t * by,
			ta * az + t * bz,
			ta * aw + t * bw
		, class):normalise()
	end
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