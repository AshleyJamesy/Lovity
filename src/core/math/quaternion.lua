--[[
- @module math.quaternion
- @brief a quaternion class
]]
class.name = "math.quaternion"

--[[
- @brief returns a new quaternion
- @param x:`number`
- @param y:`number`
- @param z:`number`
- @param w:`number`
- @return `math.quaternion`
]]
function class:quaternion(x, y, z, w)
	self[1] = x or 0.0
	self[2] = y or 0.0
	self[3] = z or 0.0
	self[4] = w or 0.0
	self:normalise()
end

--[[
- @brief normalises the quaternion
- @return `math.quaternion` self
]]
function class:normalise()
	local x, y, z, w = self[1], self[2], self[3], self[4]
	local magnitude = math.sqrt(x * x + y * y + z * z + w * w)

	self[1] = math.abs(x) > 0 and x / magnitude or 0.0
	self[2] = math.abs(y) > 0 and y / magnitude or 0.0
	self[3] = math.abs(z) > 0 and z / magnitude or 0.0
	self[4] = math.abs(w) > 0 and w / magnitude or 0.0

	return self
end

--[[
- @brief converts quaternion to matrix
- @param matrix:`math.matrix` the matrix to store the results in
- @return `math.matrix` resulting matrix provided from first argument
]]
function class:toMatrix(matrix)
	local x, y, z, w = self[1], self[2], self[3], self[4]
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
		local w4 = math.sqrt(d + 1) * 2
		self[1] = (m32 - m23) / w4
		self[2] = (m13 - m31) / w4
		self[3] = (m21 - m12) / w4
		self[4] = w4 / 4
	elseif m11 > m22 and m11 > m33 then
		local x4 = math.sqrt(1 + m11 - m22 - m33) * 2
		self[1] = x4 / 4
		self[2] = (m12 + m21) / x4
		self[3] = (m13 + m31) / x4
		self[4] = (m32 - m23) / x4
	elseif m22 > m33 then
		local y4 = math.sqrt(1 + m22 - m11 - m33) * 2
		self[1] = (m12 + m21) / y4
		self[2] = y4 / 4
		self[3] = (m23 + m32) / y4
		self[4] = (m13 - m31) / y4
	else
		local z4 = math.sqrt(1 + m33 - m11 - m22) * 2
		self[1] = (m13 + m31) / z4
		self[2] = (m23 + m32) / z4
		self[3] = y4 / 4
		self[4] = (m21 - m12) / z4
	end

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

	local ax, ay, az, aw = a[1], a[2], a[3], a[4]
	local bx, by, bz, bw = b[1], b[2], b[3], b[4]

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
		self[1],
		self[2],
		self[3],
		self[4]
	)
end

--[[
- @brief returns a string of the quaternion for tostring(`math.quaternion`)
- @return `string` "0.00, 0.00, 0.00, 1.00" to 2 decimal places
]]
function class:__tostring()
	return self:tostring(2)
end