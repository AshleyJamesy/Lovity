function math.clamp(value, min, max)
	return math.min(math.max(value, math.min(min, max)), math.max(min, max))
end

function math.inrange(value, min, max)
	return value >= math.min(min, max) and value <= math.max(min, max)
end

function math.round(n, i)
	local m = 10 ^ (i or 0)
	return math.floor(n * m + 0.5) / m
end

function math.lerp(a, b, t)
	return a + (b - a) * t
end

function math.distance(x1, y1, x2, y2)
	return math.abs(math.sqrt(((x1 - x2) ^ 2) + ((y1 - y2) ^ 2)))
end

function math.magnitude(x, y, z)
	return math.abs(math.sqrt(x * x + y * y + z * z))
end

function math.normalise(x, y, z)
	local m = math.magnitude(x, y, z)

	x = m > 0 and (x / m) or 0.0
	y = m > 0 and (y / m) or 0.0
	z = m > 0 and (z / m) or 0.0

	return x, y, z
end

function math.cross(ax, ay, az, bx, by, bz)
	return ay * bz - az * by, az * bx - ax * bz, ax * by - ay * bx
end

function math.dot(ax, ay, az, bx, by, bz)
	return ax * bx + ay * by + az * bz
end

function math.transform(x, y, angle, ox, oy, sx, sy)
	local c, s = math.cos(angle), math.sin(angle)
	return
		(((ox + x * sx) * c) - ((oy + y * sy) * s)),
		(((ox + x * sx) * s) + ((oy + y * sy) * c))
end

function math.uuid()
	local TEMPLATE ='xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

	return string.gsub(TEMPLATE, '[xy]', function(c)
		return string.format('%x', (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)):upper()
	end)
end