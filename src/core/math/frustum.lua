class.name = "math.frustum"

local function normalise(frustum, side)
	local i = side * 4

	local a = frustum[i + 1]
	local b = frustum[i + 2]
	local c = frustum[i + 3]
	local d = frustum[i + 4]

	local magnitude = math.sqrt(a * a + b * b + c * c)

	frustum[i + 1] = a / magnitude
	frustum[i + 2] = b / magnitude
	frustum[i + 3] = c / magnitude
	frustum[i + 4] = d / magnitude
end

function class:init()
	return setmetatable({ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, }, class)
end

function class.tostring(a, decimals)
	local s = ""

	for j = 0, 5 do
		for i = 0, 3 do
			s = s .. string.format("%." .. tostring(decimals or 2) .. "f, ", a[(j * 4 + i) + 1]) 
		end
		s = s .. "\n"
	end

	return s:sub(1, #s - 3)
end

function class.__tostring(a)
	return a:tostring(2)
end

function class:frustum()
end

function class.calculate(a, projection, view)
	local clip = (projection * view):transpose()

	--print("------------------- BUILDING FRUSTUM: -------------------\n")
	--print("CLIP:")
	--print(tostring(clip) .. "\n")

	for i = 1, 24 do
		a[i] = 0.0
	end

	local RIGHT	= 0
	a[RIGHT + 1] = clip[ 4] - clip[ 1]
	a[RIGHT + 2] = clip[ 8] - clip[ 5]
	a[RIGHT + 3] = clip[12] - clip[ 9]
	a[RIGHT + 4] = clip[16] - clip[13]
	normalise(a, 0)

	--print("RIGHT:")
	--print(tostring(a) .. "\n")

	local LEFT = 4
	a[LEFT + 1] = clip[ 4] + clip[ 1]
	a[LEFT + 2] = clip[ 8] + clip[ 5]
	a[LEFT + 3] = clip[12] + clip[ 9]
	a[LEFT + 4] = clip[16] + clip[13]
	normalise(a, 1)

	--print("LEFT:")
	--print(tostring(a) .. "\n")

	local BOTTOM = 8
	a[BOTTOM + 1] = clip[ 4] + clip[ 2]
	a[BOTTOM + 2] = clip[ 8] + clip[ 6]
	a[BOTTOM + 3] = clip[12] + clip[10]
	a[BOTTOM + 4] = clip[16] + clip[14]
	normalise(a, 2)

	--print("BOTTOM:")
	--print(tostring(a) .. "\n")

	local TOP = 12
	a[TOP + 1] = clip[ 4] - clip[ 2]
	a[TOP + 2] = clip[ 8] - clip[ 6]
	a[TOP + 3] = clip[12] - clip[10]
	a[TOP + 4] = clip[16] - clip[14]
	normalise(a, 3)

	--print("TOP:")
	--print(tostring(a) .. "\n")

	local BACK = 16
	a[BACK + 1] = clip[ 4] - clip[ 3]
	a[BACK + 2] = clip[ 8] - clip[ 7]
	a[BACK + 3] = clip[12] - clip[11]
	a[BACK + 4] = clip[16] - clip[15]
	normalise(a, 4)

	--print("BACK:")
	--print(tostring(a) .. "\n")

	local FRONT	= 20
	a[FRONT + 1] = clip[ 4] + clip[ 3]
	a[FRONT + 2] = clip[ 8] + clip[ 7]
	a[FRONT + 3] = clip[12] + clip[11]
	a[FRONT + 4] = clip[16] + clip[15]
	normalise(a, 5)

	--print("FRONT:")
	--print(tostring(a) .. "\n")

	--print("------------------- FINISHED FRUSTUM: -------------------\n")
end

local SIDES = {
	"RIGHT",
	"LEFT",
	"BOTTOM",
	"TOP",
	"BACK",
	"FRONT"
}

function class.pointInFrustum(frustum, x, y, z)
	--[[
	for i = 0, 5 do
		local j = i * 4

		print(SIDES[i + 1], frustum[j + 1] * x + frustum[j + 2] * y + frustum[j + 3] * z + frustum[j + 4])
	end
	]]


	for i = 0, 5 do
		local j = i * 4

		if frustum[j + 1] * x + frustum[j + 2] * y + frustum[j + 3] * z + frustum[j + 4] <= 0 then
			return false
		end
	end

	return true
end

function class.sphereInFrustum(frustum, x, y, z, radius)
	for i = 0, 5 do
		local j = i * 4

		if frustum[j + 1] * x + frustum[j + 2] * y + frustum[j + 3] * z + frustum[j + 4] <= -radius then
			return false
		end
	end

	return true
end

function class.cubeInFrustum(frustum, x, y, z, size)
	for i = 0, 5 do
		local j = i * 4

		if frustum[j + 1] * (x - size) + frustum[j + 2] * (y - size) + frustum[j + 3] * (z - size) + frustum[j + 4] > 0 then
			::continue::
		end

		if frustum[j + 1] * (x + size) + frustum[j + 2] * (y - size) + frustum[j + 3] * (z - size) + frustum[j + 4] > 0 then
			::continue::
		end

		if frustum[j + 1] * (x - size) + frustum[j + 2] * (y + size) + frustum[j + 3] * (z - size) + frustum[j + 4] > 0 then
			::continue::
		end

		if frustum[j + 1] * (x + size) + frustum[j + 2] * (y + size) + frustum[j + 3] * (z - size) + frustum[j + 4] > 0 then
			::continue::
		end

		if frustum[j + 1] * (x - size) + frustum[j + 2] * (y - size) + frustum[j + 3] * (z + size) + frustum[j + 4] > 0 then
			::continue::
		end

		if frustum[j + 1] * (x + size) + frustum[j + 2] * (y - size) + frustum[j + 3] * (z + size) + frustum[j + 4] > 0 then
			::continue::
		end

		if frustum[j + 1] * (x - size) + frustum[j + 2] * (y + size) + frustum[j + 3] * (z + size) + frustum[j + 4] > 0 then
			::continue::
		end

		if frustum[j + 1] * (x + size) + frustum[j + 2] * (y + size) + frustum[j + 3] * (z + size) + frustum[j + 4] > 0 then
			::continue::
		end

		return false
	end

	return true
end