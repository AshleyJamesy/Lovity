local abs 		= math.abs
local cos 		= math.cos
local sin 		= math.sin
local cross 	= math.cross
local dot 		= math.dot
local normalise = math.normalise
local sqrt 		= math.sqrt
local tan 		= math.tan

--[[
- @module math.matrix4
- @brief a matrix4 class
--]]
class.name = "math.matrix4"

local TEMP = setmetatable({
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0
}, class)

--[[
	@definition math.matrix4(m11, m12, m13, m14, ..., m44)
	@brief constructor for matrix4
	@param m11,m12,m13,m14 ..., m44:`number` the initial (row major)
	@return `math.matrix4` new matrix4
]]
function class:matrix4(m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44)
	self[ 1] = m11 or 0.0
	self[ 2] = m12 or 0.0
	self[ 3] = m13 or 0.0
	self[ 4] = m14 or 0.0
	self[ 5] = m21 or 0.0
	self[ 6] = m22 or 0.0
	self[ 7] = m23 or 0.0
	self[ 8] = m24 or 0.0
	self[ 9] = m31 or 0.0
	self[10] = m32 or 0.0
	self[11] = m33 or 0.0
	self[12] = m34 or 0.0
	self[13] = m41 or 0.0
	self[14] = m42 or 0.0
	self[15] = m43 or 0.0
	self[16] = m44 or 0.0
end

--[[
	@definition Addition: [`math.matrix4 + math.matrix4`], [`number + math.matrix4`], [`number + math.matrix4`]
	@brief add operator for matrix4 (a + b)
	@param a:`math.matrix4` or `number`
	@param b:`math.matrix4` or `number`
	@return `math.matrix4` new matrix4 result
]]
function class.__add(a, b)
	if type(b) == "number" then
		return setmetatable({
			a[ 1] + b,
			a[ 2] + b,
			a[ 3] + b,
			a[ 4] + b,
			a[ 5] + b,
			a[ 6] + b,
			a[ 7] + b,
			a[ 8] + b,
			a[ 9] + b,
			a[10] + b,
			a[11] + b,
			a[12] + b,
			a[13] + b,
			a[14] + b,
			a[15] + b,
			a[16] + b
		}, class)
	elseif type(a) == "number" then
		return setmetatable({
			b[ 1] + a,
			b[ 2] + a,
			b[ 3] + a,
			b[ 4] + a,
			b[ 5] + a,
			b[ 6] + a,
			b[ 7] + a,
			b[ 8] + a,
			b[ 9] + a,
			b[10] + a,
			b[11] + a,
			b[12] + a,
			b[13] + a,
			b[14] + a,
			b[15] + a,
			b[16] + a
		}, class)
	end

	return setmetatable({
		a[ 1] + b[ 1],
		a[ 2] + b[ 2],
		a[ 3] + b[ 3],
		a[ 4] + b[ 4],
		a[ 5] + b[ 5],
		a[ 6] + b[ 6],
		a[ 7] + b[ 7],
		a[ 8] + b[ 8],
		a[ 9] + b[ 9],
		a[10] + b[10],
		a[11] + b[11],
		a[12] + b[12],
		a[13] + b[13],
		a[14] + b[14],
		a[15] + b[15],
		a[16] + b[16],
	})
end

--[[
	@definition Subtraction: [`math.matrix4 - math.matrix4`], [`number - math.matrix4`], [`number - math.matrix4`]
	@brief subtract operator for matrix4 (a - b)
	@param a:`math.matrix4` or `number`
	@param b:`math.matrix4` or `number`
	@return `math.matrix4` new matrix4 result
]]
function class.__sub(a, b)
	if type(b) == "number" then
		return setmetatable({
			a[ 1] - b,
			a[ 2] - b,
			a[ 3] - b,
			a[ 4] - b,
			a[ 5] - b,
			a[ 6] - b,
			a[ 7] - b,
			a[ 8] - b,
			a[ 9] - b,
			a[10] - b,
			a[11] - b,
			a[12] - b,
			a[13] - b,
			a[14] - b,
			a[15] - b,
			a[16] - b
		}, class)
	elseif type(a) == "number" then
		return setmetatable({
			b[ 1] - a,
			b[ 2] - a,
			b[ 3] - a,
			b[ 4] - a,
			b[ 5] - a,
			b[ 6] - a,
			b[ 7] - a,
			b[ 8] - a,
			b[ 9] - a,
			b[10] - a,
			b[11] - a,
			b[12] - a,
			b[13] - a,
			b[14] - a,
			b[15] - a,
			b[16] - a
		}, class)
	end

	return setmetatable({
		a[ 1] - b[ 1],
		a[ 2] - b[ 2],
		a[ 3] - b[ 3],
		a[ 4] - b[ 4],
		a[ 5] - b[ 5],
		a[ 6] - b[ 6],
		a[ 7] - b[ 7],
		a[ 8] - b[ 8],
		a[ 9] - b[ 9],
		a[10] - b[10],
		a[11] - b[11],
		a[12] - b[12],
		a[13] - b[13],
		a[14] - b[14],
		a[15] - b[15],
		a[16] - b[16],
	}, class)
end

local function multiply(a, b)
	if type(b) == "number" then
		return
			a[ 1] * b,
			a[ 2] * b,
			a[ 3] * b,
			a[ 4] * b,
			a[ 5] * b,
			a[ 6] * b,
			a[ 7] * b,
			a[ 8] * b,
			a[ 9] * b,
			a[10] * b,
			a[11] * b,
			a[12] * b,
			a[13] * b,
			a[14] * b,
			a[15] * b,
			a[16] * b
	elseif type(a) == "number" then
		return
			b[ 1] * a,
			b[ 2] * a,
			b[ 3] * a,
			b[ 4] * a,
			b[ 5] * a,
			b[ 6] * a,
			b[ 7] * a,
			b[ 8] * a,
			b[ 9] * a,
			b[10] * a,
			b[11] * a,
			b[12] * a,
			b[13] * a,
			b[14] * a,
			b[15] * a,
			b[16] * a
	end

	return
		a[ 1] * b[ 1] + a[ 2] * b[ 5] + a[ 3] * b[ 9] + a[ 4] * b[13],
		a[ 1] * b[ 2] + a[ 2] * b[ 6] + a[ 3] * b[10] + a[ 4] * b[14],
		a[ 1] * b[ 3] + a[ 2] * b[ 7] + a[ 3] * b[11] + a[ 4] * b[15],
		a[ 1] * b[ 4] + a[ 2] * b[ 8] + a[ 3] * b[12] + a[ 4] * b[16],
		a[ 5] * b[ 1] + a[ 6] * b[ 5] + a[ 7] * b[ 9] + a[ 8] * b[13],
		a[ 5] * b[ 2] + a[ 6] * b[ 6] + a[ 7] * b[10] + a[ 8] * b[14],
		a[ 5] * b[ 3] + a[ 6] * b[ 7] + a[ 7] * b[11] + a[ 8] * b[15],
		a[ 5] * b[ 4] + a[ 6] * b[ 8] + a[ 7] * b[12] + a[ 8] * b[16],
		a[ 9] * b[ 1] + a[10] * b[ 5] + a[11] * b[ 9] + a[12] * b[13],
		a[ 9] * b[ 2] + a[10] * b[ 6] + a[11] * b[10] + a[12] * b[14],
		a[ 9] * b[ 3] + a[10] * b[ 7] + a[11] * b[11] + a[12] * b[15],
		a[ 9] * b[ 4] + a[10] * b[ 8] + a[11] * b[12] + a[12] * b[16],
		a[13] * b[ 1] + a[14] * b[ 5] + a[15] * b[ 9] + a[16] * b[13],
		a[13] * b[ 2] + a[14] * b[ 6] + a[15] * b[10] + a[16] * b[14],
		a[13] * b[ 3] + a[14] * b[ 7] + a[15] * b[11] + a[16] * b[15],
		a[13] * b[ 4] + a[14] * b[ 8] + a[15] * b[12] + a[16] * b[16]
end

--[[
	@definition Multiplication: [`math.matrix4 * math.matrix4`], [`number * math.matrix4`], [`number * math.matrix4`]
	@brief multiply operator for matrix4 (a * b)
	@param a:`math.matrix4` or `number`
	@param b:`math.matrix4` or `number`
	@return `math.matrix4` new matrix4 result
]]
function class.__mul(a, b)
	return setmetatable({
		multiply(a, b)
	}, class)
end

function class.multiply(a, b)
	return multiply(a, b)
end

--[[
	@definition Division: [`math.matrix4 / math.matrix4`], [`number / math.matrix4`], [`number / math.matrix4`]
	@brief divide operator for matrix4 (a / b)
	@param a:`math.matrix4` or `number`
	@param b:`math.matrix4` or `number`
	@return `math.matrix4` new matrix4 result
]]
function class.__div(a, b)
	if type(b) == "number" then
		return setmetatable({
			a[ 1] / b,
			a[ 2] / b,
			a[ 3] / b,
			a[ 4] / b,
			a[ 5] / b,
			a[ 6] / b,
			a[ 7] / b,
			a[ 8] / b,
			a[ 9] / b,
			a[10] / b,
			a[11] / b,
			a[12] / b,
			a[13] / b,
			a[14] / b,
			a[15] / b,
			a[16] / b
		}, class)
	elseif type(a) == "number" then
		return setmetatable({
			b[ 1] / a,
			b[ 2] / a,
			b[ 3] / a,
			b[ 4] / a,
			b[ 5] / a,
			b[ 6] / a,
			b[ 7] / a,
			b[ 8] / a,
			b[ 9] / a,
			b[10] / a,
			b[11] / a,
			b[12] / a,
			b[13] / a,
			b[14] / a,
			b[15] / a,
			b[16] / a
		}, class)
	end

	error("cannot divide two matrices!")
end

--[[
	@exclude
]]
function class.__mod()
	error("modulus not supported")
end

--[[
	@definition Unary: [`-math.matrix4`]
	@brief unary minus operator for matrix4
	@return `math.matrix4` matrix `self` with negated values
]]
function class.__unm(a)
	return setmetatable({
		-a[ 1],
		-a[ 2],
		-a[ 3],
		-a[ 4],
		-a[ 5],
		-a[ 6],
		-a[ 7],
		-a[ 8],
		-a[ 9],
		-a[10],
		-a[11],
		-a[12],
		-a[13],
		-a[14],
		-a[15],
		-a[16]
	})
end

--[[
	@definition Equality: [`math.matrix4 == math.matrix4`]
	@brief equality operator for matrix4 (a == b)
	@return `boolean` `true` if a and b are equal, else `false`
]]
function class.__eq(a, b)
	return (
		a[ 1] == b[ 1] and 
		a[ 2] == b[ 2] and 
		a[ 3] == b[ 3] and 
		a[ 4] == b[ 4] and 
		a[ 5] == b[ 5] and 
		a[ 6] == b[ 6] and 
		a[ 7] == b[ 7] and 
		a[ 8] == b[ 8] and 
		a[ 9] == b[ 9] and 
		a[10] == b[10] and 
		a[11] == b[11] and 
		a[12] == b[12] and 
		a[13] == b[13] and 
		a[14] == b[14] and 
		a[15] == b[15] and 
		a[16] == b[16]
	)
end

--[[
	@definition Length: [`#math.matrix4`]
	@brief # operator for matrix4 (returns length)
	@return `number` 4
]]
function class.__len(a)
	return 4
end

--[[
	@definition matrix4:clone()
	@brief returns a copy of the matrix4
	@return `math.matrix4` new matrix4 copied from self
]]
function class:clone()
	return setmetatable({ unpack(self) }, class)
end

--[[
	@definition matrix4:copy(from)
	@brief copies matrix4 values from another matrix4
	@param from:`math.matrix4` the matrix to copy from
	@return `math.matrix4` self with values copied from `from`
]]
function class.copy(a, b)
	a[ 1] = b[ 1]
	a[ 2] = b[ 2]
	a[ 3] = b[ 3]
	a[ 4] = b[ 4]
	a[ 5] = b[ 5]
	a[ 6] = b[ 6]
	a[ 7] = b[ 7]
	a[ 8] = b[ 8]
	a[ 9] = b[ 9]
	a[10] = b[10]
	a[11] = b[11]
	a[12] = b[12]
	a[13] = b[13]
	a[14] = b[14]
	a[15] = b[15]
	a[16] = b[16]

	return a
end

--[[
	@definition matrix4:identity()
	@brief sets the matrix4 to an identity matrix
	@return `math.matrix4` self as identity matrix
]]
function class.identity(a)
	a[ 1] = 1.0
	a[ 2] = 0.0
	a[ 3] = 0.0
	a[ 4] = 0.0
	a[ 5] = 0.0
	a[ 6] = 0.0
	a[ 7] = 1.0
	a[ 8] = 0.0
	a[ 9] = 0.0
	a[10] = 0.0
	a[11] = 0.0
	a[12] = 1.0
	a[13] = 0.0
	a[14] = 0.0
	a[15] = 0.0
	a[16] = 1.0

	return a
end

--[[
	@definition matrix4:scale(x, y, z)
	@brief sets the matrix4 to a scaled matrix
	@param x:`number` x scale
	@param y:`number` y scale
	@param z:`number` z scale
	@return `math.matrix4` self as scaled matrix
]]
function class.scale(a, x, y, z)
	a[ 1] = x or 1.0
	a[ 2] = 0.0
	a[ 3] = 0.0
	a[ 4] = 0.0
	a[ 5] = 0.0
	a[ 6] = y or 1.0
	a[ 7] = 0.0
	a[ 8] = 0.0
	a[ 9] = 0.0
	a[10] = 0.0
	a[11] = z or 1.0
	a[12] = 0.0
	a[13] = 0.0
	a[14] = 0.0
	a[15] = 0.0
	a[16] = 1.0

	return a
end

--[[
	@definition matrix4:set(m11, m12, m13, m14, ..., m44)
	@note values which are not specified are set to `0.0`
	@brief sets the matrix4 with given values
	@param 1,2,3 ..., 16:`number` (row major)
	@return `math.matrix4` self with new values
]]
function class.set(a, m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44)
	a[ 1] = m11 or 0.0
	a[ 2] = m12 or 0.0
	a[ 3] = m13 or 0.0
	a[ 4] = m14 or 0.0
	a[ 5] = m21 or 0.0
	a[ 6] = m22 or 0.0
	a[ 7] = m23 or 0.0
	a[ 8] = m24 or 0.0
	a[ 9] = m31 or 0.0
	a[10] = m32 or 0.0
	a[11] = m33 or 0.0
	a[12] = m34 or 0.0
	a[13] = m41 or 0.0
	a[14] = m42 or 0.0
	a[15] = m43 or 0.0
	a[16] = m44 or 0.0

	return a
end

--[[
	@definition matrix4:quaternion(x, y, z, w)
	@brief sets the matrix4 to a quaternion matrix
	@param x:'number' quaternion x component
	@param y:'number' quaternion y component
	@param z:'number' quaternion z component
	@param w:'number' quaternion w component
	@return `math.matrix4` self as quaternion matrix
]]
function class:quaternion(a, x, y, z, w)
	a[ 1] = 1 - 2 * y ^ 2 - 2 * z ^ 2
	a[ 2] = 2 * x * y - 2 * z * w
	a[ 3] = 2 * x * z + 2 * y * w
	a[ 4] =  0.0
	a[ 5] = 2 * x * y + 2 * z * w
	a[ 6] = 1 - 2 * x ^ 2 - 2 * z ^ 2
	a[ 7] = 2 * y * z - 2 * x * w
	a[ 8] =  0.0
	a[ 9] = 2 * x * z - 2 * y * w
	a[10] = 2 * y * z + 2 * x * w
	a[11] = 1 - 2 * x ^ 2 - 2 * y ^ 2  
	a[12] =  0.0
	a[13] =  0.0
	a[14] =  0.0
	a[15] =  0.0
	a[16] =  1.0

	return a
end

--[[
	@definition matrix4:rotate(x, y, z)
	@brief sets the matrix4 to a rotation matrix
	@param x:'number' rotation x axis in radians
	@param y:'number' rotation y axis in radians
	@param z:'number' rotation z axis in radians
	@return `math.matrix4` self as rotation matrix
]]
function class.rotate(a, x, y, z)
	local cx, sx = cos(x or 0.0), sin(x or 0.0)
	local cy, sy = cos(y or 0.0), sin(y or 0.0)
	local cz, sz = cos(z or 0.0), sin(z or 0.0)

	a[ 1] =  cz * cy
	a[ 2] =  cy * sz
	a[ 3] =  sy
	a[ 4] =  0.0
	a[ 5] = -sx * -sy * cz + cx * -sz
	a[ 6] = -sx * -sy * sz + cx *  cz
	a[ 7] = -sx *  cy
	a[ 8] =  0.0
	a[ 9] =  cx * -sy * cz + sx * -sz
	a[10] =  cx * -sy * sz + sx *  cz
	a[11] =  cx *  cy
	a[12] =  0.0
	a[13] =  0.0
	a[14] =  0.0
	a[15] =  0.0
	a[16] =  1.0

	return a
end

--[[
- @brief sets the matrix4 to a rotation matrix along the x axis
- @param a:`math.matrix`
- @param x:'number' rotation on x axis in radians
- @return `math.matrix4` matrix `a` as rotation matrix along the x axis
]]
function class.rotateX(a, x)
	local c, s = cos(x), sin(x)

	a[ 1] = 1.0
	a[ 2] = 0.0
	a[ 3] = 0.0
	a[ 4] = 0.0
	a[ 5] = 0.0
	a[ 6] = c
	a[ 7] = s
	a[ 8] = 0.0
	a[ 9] = 0.0
	a[10] = -s
	a[11] = c
	a[12] = 0.0
	a[13] = 0.0
	a[14] = 0.0
	a[15] = 0.0
	a[16] = 1.0

	return a
end

--[[
- @brief sets the matrix4 to a rotation matrix along the y axis
- @param a:`math.matrix`
- @param y:'number' rotation on y axis in radians
- @return `math.matrix4` matrix `a` as rotation matrix along the y axis
]]
function class.rotateY(a, y)
	local c, s = cos(y), sin(y)

	a[ 1] = c
	a[ 2] = 0.0
	a[ 3] = s
	a[ 4] = 0.0
	a[ 5] = 0.0
	a[ 6] = 1.0
	a[ 7] = 0.0
	a[ 8] = 0.0
	a[ 9] = -s
	a[10] = 0.0
	a[11] = c
	a[12] = 0.0
	a[13] = 0.0
	a[14] = 0.0
	a[15] = 0.0
	a[16] = 1.0

	return a
end

--[[
- @brief sets the matrix4 to a rotation matrix along the z axis
- @param a:`math.matrix`
- @param z:'number' rotation on z axis in radians
- @return `math.matrix4` matrix `a` as rotation matrix along the z axis
]]
function class.rotateZ(a, z)
	local c, s = cos(z), sin(z)

	a[1] = c
	a[2] = s
	a[3] = 0.0
	a[4] = 0.0
	a[5] = -s
	a[6] = c
	a[7] = 0.0
	a[8] = 0.0
	a[9] = 0.0
	a[10] = 0.0
	a[11] = 1.0
	a[12] = 0.0
	a[13] = 0.0
	a[14] = 0.0
	a[15] = 0.0
	a[16] = 1.0

	return a
end

--[[
- @brief sets the matrix4 to a translation matrix given x,y,z
- @param a:`math.matrix`
- @param x:'number' the x translation
- @param y:'number' the y translation
- @param z:'number' the z translation
- @return `math.matrix4` matrix `a` as translation matrix x,y,z
]]
function class.translate(a, x, y, z)
	a[ 1] = 1.0
	a[ 2] = 0.0
	a[ 3] = 0.0
	a[ 4] = x or 0.0
	a[ 5] = 0.0
	a[ 6] = 1.0
	a[ 7] = 0.0
	a[ 8] = y or 0.0
	a[ 9] = 0.0
	a[10] = 0.0
	a[11] = 1.0
	a[12] = z or 0.0
	a[13] = 0.0
	a[14] = 0.0
	a[15] = 0.0
	a[16] = 1.0

	return a
end

--[[
- @brief sets the matrix4 to a perspective matrix
- @param a:`math.matrix`
- @param fov:'number' the field of view in radians
- @param aspect:'number' the aspect ratio of the screen
- @param near:'number' the near clipping plane
- @param far:'number' the far clipping plane
- @return `math.matrix4` matrix `a` as perspective matrix
]]
function class.perspective(a, fov, aspect, near, far)
	assert(aspect ~= 0)

	--[[
	a[ 1] = 1 / (aspect * tan(fov * 0.5))
	a[ 2] = 0.0
	a[ 3] = 0.0
	a[ 4] = 0.0
	a[ 5] = 0.0
	a[ 6] = -1 / tan(fov * 0.5)
	a[ 7] = 0.0
	a[ 8] = 0.0
	a[ 9] = 0.0
	a[10] = 0.0
	a[11] = -2 / (far - near) --TODO: fix far clipping plane issue
	a[12] = -((far + near) / (far - near))
	a[13] = 0.0
	a[14] = 0.0
	a[15] = -1.0
	a[16] = 0.0
	]]
	
	local o = 1 / tan(fov / 2)
    local t = 1 / aspect
    local d = 1 / (far - near)

    a[ 1] = o * t
	a[ 2] = 0.0
	a[ 3] = 0.0
	a[ 4] = 0.0
	a[ 5] = 0.0
	a[ 6] = -o
	a[ 7] = 0.0
	a[ 8] = 0.0
	a[ 9] = 0.0
	a[10] = 0.0
	a[11] = -d * (far + near)
	a[12] = -d * 2 * far * near
	a[13] = 0.0
	a[14] = 0.0
	a[15] = -1.0
	a[16] = 0.0

	return a
end

--[[
- @brief inverses the matrix4
- @param a:`math.matrix`
- @return `math.matrix4` matrix `a` as inversed matrix
]]
function class.inverse(a)
	TEMP[ 1] =  a[6] * a[11] * a[16] - a[6] * a[12] * a[15] - a[10] * a[7] * a[16] + a[10] * a[8] * a[15] + a[14] * a[7] * a[12] - a[14] * a[8] * a[11]
	TEMP[ 2] = -a[2] * a[11] * a[16] + a[2] * a[12] * a[15] + a[10] * a[3] * a[16] - a[10] * a[4] * a[15] - a[14] * a[3] * a[12] + a[14] * a[4] * a[11]
	TEMP[ 3] =  a[2] * a[7]  * a[16] - a[2] * a[8]  * a[15] - a[6]  * a[3] * a[16] + a[6]  * a[4] * a[15] + a[14] * a[3] * a[8]  - a[14] * a[4] * a[7]
	TEMP[ 4] = -a[2] * a[7]  * a[12] + a[2] * a[8]  * a[11] + a[6]  * a[3] * a[12] - a[6]  * a[4] * a[11] - a[10] * a[3] * a[8]  + a[10] * a[4] * a[7]
	TEMP[ 5] = -a[5] * a[11] * a[16] + a[5] * a[12] * a[15] + a[9]  * a[7] * a[16] - a[9]  * a[8] * a[15] - a[13] * a[7] * a[12] + a[13] * a[8] * a[11]
	TEMP[ 6] =  a[1] * a[11] * a[16] - a[1] * a[12] * a[15] - a[9]  * a[3] * a[16] + a[9]  * a[4] * a[15] + a[13] * a[3] * a[12] - a[13] * a[4] * a[11]
	TEMP[ 7] = -a[1] * a[7]  * a[16] + a[1] * a[8]  * a[15] + a[5]  * a[3] * a[16] - a[5]  * a[4] * a[15] - a[13] * a[3] * a[8]  + a[13] * a[4] * a[7]
	TEMP[ 8] =  a[1] * a[7]  * a[12] - a[1] * a[8]  * a[11] - a[5]  * a[3] * a[12] + a[5]  * a[4] * a[11] + a[9]  * a[3] * a[8]  - a[9]  * a[4] * a[7]
	TEMP[ 9] =  a[5] * a[10] * a[16] - a[5] * a[12] * a[14] - a[9]  * a[6] * a[16] + a[9]  * a[8] * a[14] + a[13] * a[6] * a[12] - a[13] * a[8] * a[10]
	TEMP[10] = -a[1] * a[10] * a[16] + a[1] * a[12] * a[14] + a[9]  * a[2] * a[16] - a[9]  * a[4] * a[14] - a[13] * a[2] * a[12] + a[13] * a[4] * a[10]
	TEMP[11] =  a[1] * a[6]  * a[16] - a[1] * a[8]  * a[14] - a[5]  * a[2] * a[16] + a[5]  * a[4] * a[14] + a[13] * a[2] * a[8]  - a[13] * a[4] * a[6]
	TEMP[12] = -a[1] * a[6]  * a[12] + a[1] * a[8]  * a[10] + a[5]  * a[2] * a[12] - a[5]  * a[4] * a[10] - a[9]  * a[2] * a[8]  + a[9]  * a[4] * a[6]
	TEMP[13] = -a[5] * a[10] * a[15] + a[5] * a[11] * a[14] + a[9]  * a[6] * a[15] - a[9]  * a[7] * a[14] - a[13] * a[6] * a[11] + a[13] * a[7] * a[10]
	TEMP[14] =  a[1] * a[10] * a[15] - a[1] * a[11] * a[14] - a[9]  * a[2] * a[15] + a[9]  * a[3] * a[14] + a[13] * a[2] * a[11] - a[13] * a[3] * a[10]
	TEMP[15] = -a[1] * a[6]  * a[15] + a[1] * a[7]  * a[14] + a[5]  * a[2] * a[15] - a[5]  * a[3] * a[14] - a[13] * a[2] * a[7]  + a[13] * a[3] * a[6]
	TEMP[16] =  a[1] * a[6]  * a[11] - a[1] * a[7]  * a[10] - a[5]  * a[2] * a[11] + a[5]  * a[3] * a[10] + a[9]  * a[2] * a[7]  - a[9]  * a[3] * a[6]
	
	local det = a[1] * TEMP[1] + a[2] * TEMP[5] + a[3] * TEMP[9] + a[4] * TEMP[13]
	
	if det == 0 then 
		return a 
	end
	
	det = 1 / det
	
	for i = 1, 16 do
		a[i] = TEMP[i] * det
	end
	
	return a
end

--[[
- @brief transposes the matrix4
- @param a:`math.matrix`
- @return `math.matrix4` matrix `a` tranposed
]]
function class.transpose(a)
	TEMP[ 1] = a[ 1]
	TEMP[ 2] = a[ 5]
	TEMP[ 3] = a[ 9]
	TEMP[ 4] = a[13]
	TEMP[ 5] = a[ 2]
	TEMP[ 6] = a[ 6]
	TEMP[ 7] = a[10]
	TEMP[ 8] = a[14]
	TEMP[ 9] = a[ 3]
	TEMP[10] = a[ 7]
	TEMP[11] = a[11]
	TEMP[12] = a[15]
	TEMP[13] = a[ 4]
	TEMP[14] = a[ 8]
	TEMP[15] = a[12]
	TEMP[16] = a[16]

	for i = 1, 16 do
		a[i] = TEMP[i]
	end

	return a
end

--[[
- @brief returns a string of the matrix4
- @param **a**:`math.matrix`
- @param **decimals**:`number` the number of decimals to display, default is 2
- @return `string` "1.00, 0.00, 0.00, 0.00<br />,0.00, 1.00, 0.00, 0.00<br />,0.00, 0.00, 1.00, 0.00<br />,0.00, 0.00, 0.00, 1.00"
]]
function class.tostring(a, decimals)
	local s = ""

	for j = 0, 3 do
		for i = 0, 3 do
			s = s .. string.format("%." .. tostring(decimals or 2) .. "f, ", a[(j * 4 + i) + 1]) 
		end
		s = s .. "\n"
	end

	return s:sub(1, #s - 3)
end

--[[
- @brief returns a string of the matrix4 for tostring(`math.matrix4`) to 2 decimal places
- @return `string` "1.00, 0.00, 0.00, 0.00<br />,0.00, 1.00, 0.00, 0.00<br />,0.00, 0.00, 1.00, 0.00<br />,0.00, 0.00, 0.00, 1.00"
]]
function class.__tostring(a)
	return a:tostring(2)
end