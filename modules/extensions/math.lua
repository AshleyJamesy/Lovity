local abs = math.abs
local cos = math.cos
local floor = math.floor
local max = math.max
local min = math.min
local random = math.random
local sin = math.sin
local sqrt = math.sqrt
local format = string.format
local gsub = string.gsub

function math.clamp(value, low, high)
	return min(max(value, min(low, high)), max(low, high))
end

function math.cross(ax, ay, az, bx, by, bz)
	return ay * bz - az * by, az * bx - ax * bz, ax * by - ay * bx
end

function math.distance(x1, y1, x2, y2)
	return abs(sqrt(((x1 - x2) ^ 2) + ((y1 - y2) ^ 2)))
end

function math.dot(ax, ay, az, bx, by, bz)
	return ax * bx + ay * by + az * bz
end

function math.inrange(value, low, high)
	return value >= min(low, high) and value <= max(low, high)
end

function math.lerp(a, b, t)
	return a + (b - a) * t
end

local function magnitude(x, y, z)
	return abs(sqrt(x * x + y * y + z * z))
end
math.magnitude = magnitude

function math.normalise(x, y, z)
	local m = magnitude(x, y, z)

	x = m > 0 and (x / m) or 0.0
	y = m > 0 and (y / m) or 0.0
	z = m > 0 and (z / m) or 0.0

	return x, y, z
end

function math.round(n, i)
	local m = 10 ^ (i or 0)
	return floor(n * m + 0.5) / m
end

function math.transform(x, y, angle, ox, oy, sx, sy)
	local c, s = cos(angle), sin(angle)
	return
		(((ox + x * sx) * c) - ((oy + y * sy) * s)),
		(((ox + x * sx) * s) + ((oy + y * sy) * c))
end

local function replacement(c)
	return format('%x', (c == 'x') and random(0, 0xf) or random(8, 0xb)):upper()
end

function math.uuid()
	return gsub('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', '[xy]', replacement)
end