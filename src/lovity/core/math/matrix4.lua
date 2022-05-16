local assert = assert
local abs = math.abs
local cos = math.cos
local cross = math.cross
local dot = math.dot
local normalise = math.normalise
local setmetatable = setmetatable
local sin = math.sin
local sqrt = math.sqrt
local tan = math.tan

local TEMP = setmetatable({
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0
}, matrix4)

function matrix4:matrix4(m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44)
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

	return self
end

function matrix4.__add(a, b)
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
		}, matrix4)
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
		}, matrix4)
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
	}, matrix4)
end

function matrix4.__sub(a, b)
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
		}, matrix4)
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
		}, matrix4)
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
	}, matrix4)
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

function matrix4.__mul(a, b)
	return setmetatable({
		multiply(a, b)
	}, matrix4)
end

function matrix4.multiply(a, b)
	return multiply(a, b)
end

function matrix4.__div(a, b)
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
		}, matrix4)
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
		}, matrix4)
	end

	error("cannot divide two matrices!")
end

function matrix4.__mod()
	error("modulus not supported")
end

function matrix4.__unm(a)
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
	}, matrix4)
end

function matrix4.__eq(a, b)
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

function matrix4.__len(a)
	return 4
end

function matrix4:clone()
	return setmetatable({ unpack(self) }, matrix4)
end

function matrix4.copy(a, b)
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

function matrix4.identity(a)
	a[ 1] = 1.0
	a[ 2] = 0.0
	a[ 3] = 0.0
	a[ 4] = 0.0
	a[ 5] = 0.0
	a[ 6] = 1.0
	a[ 7] = 0.0
	a[ 8] = 0.0
	a[ 9] = 0.0
	a[10] = 0.0
	a[11] = 1.0
	a[12] = 0.0
	a[13] = 0.0
	a[14] = 0.0
	a[15] = 0.0
	a[16] = 1.0

	return a
end

function matrix4.scale(a, x, y, z)
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

function matrix4.set(a, m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44)
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

function matrix4:quaternion(a, x, y, z, w)
	local xx = 2 * x * x
	local xy = 2 * x * y
	local xz = 2 * x * z
	local xw = 2 * x * w
	local yy = 2 * y * y
	local yz = 2 * y * z
	local yw = 2 * y * w
	local zz = 2 * z * z
	local zw = 2 * z * w

	a[ 1] = 1 - yy - zz
	a[ 2] = xy - zw
	a[ 3] = xz + yw
	a[ 4] = 0.0
	a[ 5] = xy + zw
	a[ 6] = 1 - xx - zz
	a[ 7] = yz - xw
	a[ 8] = 0.0
	a[ 9] = xz - yw
	a[10] = yz + xw
	a[11] = 1 - xx - yy
	a[12] = 0.0
	a[13] = 0.0
	a[14] = 0.0
	a[15] = 0.0
	a[16] = 1.0

	return a
end

function matrix4.euler(a, x, y, z)
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

function matrix4.eulerX(a, x)
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

function matrix4.eulerY(a, y)
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

function matrix4.eulerZ(a, z)
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

function matrix4.translate(a, x, y, z)
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

function matrix4.transform(a, sx, sy, sz, tx, ty, tz, rx, ry, rz, rw)
	local rxx = 2 * rx * rx
	local rxy = 2 * rx * ry
	local rxz = 2 * rx * rz
	local rxw = 2 * rx * rw
	local ryy = 2 * ry * ry
	local ryz = 2 * ry * rz
	local ryw = 2 * ry * rw
	local rzz = 2 * rz * rz
	local rzw = 2 * rz * rw 

	a[ 1] = (1 - ryy - rzz) * sx
	a[ 2] = (rxy - rzw) * sy
	a[ 3] = (rxz + ryw) * sz
	a[ 4] = tx
	a[ 5] = (rxy + rzw) * sx
	a[ 6] = (1 - rxx - rzz) * sy
	a[ 7] = (ryz - rxw) * sz
	a[ 8] = ty
	a[ 9] = (rxz - ryw) * sx
	a[10] = (ryz + rxw) * sy
	a[11] = (1 - rxx - ryy) * sz
	a[12] = tz
	a[13] = 0.0
	a[14] = 0.0
	a[15] = 0.0
	a[16] = 1.0

	return a
end

function matrix4.perspective(a, fov, aspect, near, far)
	assert(aspect ~= 0)
	
	a[ 1] = 1 / (aspect * tan(fov * 0.5))
	a[ 2] = 0.0
	a[ 3] = 0.0
	a[ 4] = 0.0
	a[ 5] = 0.0
	a[ 6] = 1 / tan(fov * 0.5)
	a[ 7] = 0.0
	a[ 8] = 0.0
	a[ 9] = 0.0
	a[10] = 0.0
	a[11] = -((far + near) / (far - near))
	a[12] = -((2 * far * near) / (far - near))
	a[13] = 0.0
	a[14] = 0.0
	a[15] = -1.0
	a[16] = 0.0

	return a
end

function matrix4.lookAt(a, ex, ey, ez, tx, ty, tz, ux, uy, uz)
	local zx,zy,zz = normalise(tx - ex, ty - ey, tz - ez)
	local xx,xy,xz = normalise(cross(zx, zy, zz, ux, uy, uz))
	local yx,yy,yz = cross(xx, xy, xz, zx, zy, zz)

	zx, zy, zz = -zx, -zy, -zz

	a[ 1] = xx
	a[ 2] = xy
	a[ 3] = xz
	a[ 4] = -dot(xx,xy,xz,ex,ey,ez)
	a[ 5] = yx
	a[ 6] = yy
	a[ 7] = yz
	a[ 8] = -dot(yx,yy,yz,ex,ey,ez)
	a[ 9] = zx
	a[10] = zy
	a[11] = zz
	a[12] = -dot(zx,zy,zz,ex,ey,ez)
	a[13] = 0.0
	a[14] = 0.0
	a[15] = 0.0
	a[16] = 1.0

	return a
end

function matrix4.orthographic(a, l, r, t, b, n, f)
	local rl = r - l
	local tb = t - b
	local fn = f - n

	a[ 1] = 2 / rl
	a[ 2] = 0.0
	a[ 3] = 0.0
	a[ 4] = -((r + l) / rl)
	a[ 5] = 0.0
	a[ 6] = 2 / tb
	a[ 7] = 0.0
	a[ 8] = -((t + b) / tb)
	a[ 9] = 0.0
	a[10] = 0.0
	a[11] = -2 / fn
	a[12] = -((f + n) / fn)
	a[13] = 0.0
	a[14] = 0.0
	a[15] = 0.0
	a[16] = 1.0

	return a
end

function matrix4.inverse(a)
	TEMP[ 1] =  a[6] * a[11] * a[16] - a[6] * a[12] * a[15] - a[10] * a[7] * a[16] + a[10] * a[8] * a[15] + a[14] * a[7] * a[12] - a[14] * a[8] * a[11]
	TEMP[ 2] = -a[2] * a[11] * a[16] + a[2] * a[12] * a[15] + a[10] * a[3] * a[16] - a[10] * a[4] * a[15] - a[14] * a[3] * a[12] + a[14] * a[4] * a[11]
	TEMP[ 3] =  a[2] * a[ 7] * a[16] - a[2] * a[ 8] * a[15] - a[ 6] * a[3] * a[16] + a[ 6] * a[4] * a[15] + a[14] * a[3] * a[ 8] - a[14] * a[4] * a[ 7]
	TEMP[ 4] = -a[2] * a[ 7] * a[12] + a[2] * a[ 8] * a[11] + a[ 6] * a[3] * a[12] - a[ 6] * a[4] * a[11] - a[10] * a[3] * a[ 8] + a[10] * a[4] * a[ 7]
	TEMP[ 5] = -a[5] * a[11] * a[16] + a[5] * a[12] * a[15] + a[ 9] * a[7] * a[16] - a[ 9] * a[8] * a[15] - a[13] * a[7] * a[12] + a[13] * a[8] * a[11]
	TEMP[ 6] =  a[1] * a[11] * a[16] - a[1] * a[12] * a[15] - a[ 9] * a[3] * a[16] + a[ 9] * a[4] * a[15] + a[13] * a[3] * a[12] - a[13] * a[4] * a[11]
	TEMP[ 7] = -a[1] * a[ 7] * a[16] + a[1] * a[ 8] * a[15] + a[ 5] * a[3] * a[16] - a[ 5] * a[4] * a[15] - a[13] * a[3] * a[ 8] + a[13] * a[4] * a[ 7]
	TEMP[ 8] =  a[1] * a[ 7] * a[12] - a[1] * a[ 8] * a[11] - a[ 5] * a[3] * a[12] + a[ 5] * a[4] * a[11] + a[ 9] * a[3] * a[ 8] - a[ 9] * a[4] * a[ 7]
	TEMP[ 9] =  a[5] * a[10] * a[16] - a[5] * a[12] * a[14] - a[ 9] * a[6] * a[16] + a[ 9] * a[8] * a[14] + a[13] * a[6] * a[12] - a[13] * a[8] * a[10]
	TEMP[10] = -a[1] * a[10] * a[16] + a[1] * a[12] * a[14] + a[ 9] * a[2] * a[16] - a[ 9] * a[4] * a[14] - a[13] * a[2] * a[12] + a[13] * a[4] * a[10]
	TEMP[11] =  a[1] * a[ 6] * a[16] - a[1] * a[ 8] * a[14] - a[ 5] * a[2] * a[16] + a[ 5] * a[4] * a[14] + a[13] * a[2] * a[ 8] - a[13] * a[4] * a[ 6]
	TEMP[12] = -a[1] * a[ 6] * a[12] + a[1] * a[ 8] * a[10] + a[ 5] * a[2] * a[12] - a[ 5] * a[4] * a[10] - a[ 9] * a[2] * a[ 8] + a[ 9] * a[4] * a[ 6]
	TEMP[13] = -a[5] * a[10] * a[15] + a[5] * a[11] * a[14] + a[ 9] * a[6] * a[15] - a[ 9] * a[7] * a[14] - a[13] * a[6] * a[11] + a[13] * a[7] * a[10]
	TEMP[14] =  a[1] * a[10] * a[15] - a[1] * a[11] * a[14] - a[ 9] * a[2] * a[15] + a[ 9] * a[3] * a[14] + a[13] * a[2] * a[11] - a[13] * a[3] * a[10]
	TEMP[15] = -a[1] * a[ 6] * a[15] + a[1] * a[ 7] * a[14] + a[ 5] * a[2] * a[15] - a[ 5] * a[3] * a[14] - a[13] * a[2] * a[ 7] + a[13] * a[3] * a[ 6]
	TEMP[16] =  a[1] * a[ 6] * a[11] - a[1] * a[ 7] * a[10] - a[ 5] * a[2] * a[11] + a[ 5] * a[3] * a[10] + a[ 9] * a[2] * a[ 7] - a[ 9] * a[3] * a[ 6]
	
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

function matrix4.transpose(a)
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

function matrix4.tostring(a, decimals)
	local s = ""

	for j = 0, 3 do
		for i = 0, 3 do
			s = s .. string.format("%." .. tostring(decimals or 2) .. "f, ", a[(j * 4 + i) + 1])
		end
		s = s .. "\n"
	end

	return s:sub(1, #s - 3)
end

function matrix4.__tostring(a)
	return a:tostring(2)
end