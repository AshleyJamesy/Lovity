import "lovity.core.math.matrix4"

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

function frustum:frustum()
	self.clip = matrix4()

	for i = 1, 24 do
		self[i] = 0.0
	end

	return self
end

function frustum:calculate(projection, view)
	--TODO:
	--[[
		https://github.com/gametutorials/tutorials/blob/master/OpenGL/Frustum%20Culling/Frustum.cpp
		Does not tranpose their clipping matrix AND uses model * projection, could be an issue with my matrix multiplication/order
	]]--
	local clip = self.clip:set(
		projection[ 1] * view[ 1] + projection[ 2] * view[ 5] + projection[ 3] * view[ 9] + projection[ 4] * view[13],
		projection[ 1] * view[ 2] + projection[ 2] * view[ 6] + projection[ 3] * view[10] + projection[ 4] * view[14],
		projection[ 1] * view[ 3] + projection[ 2] * view[ 7] + projection[ 3] * view[11] + projection[ 4] * view[15],
		projection[ 1] * view[ 4] + projection[ 2] * view[ 8] + projection[ 3] * view[12] + projection[ 4] * view[16],
		projection[ 5] * view[ 1] + projection[ 6] * view[ 5] + projection[ 7] * view[ 9] + projection[ 8] * view[13],
		projection[ 5] * view[ 2] + projection[ 6] * view[ 6] + projection[ 7] * view[10] + projection[ 8] * view[14],
		projection[ 5] * view[ 3] + projection[ 6] * view[ 7] + projection[ 7] * view[11] + projection[ 8] * view[15],
		projection[ 5] * view[ 4] + projection[ 6] * view[ 8] + projection[ 7] * view[12] + projection[ 8] * view[16],
		projection[ 9] * view[ 1] + projection[10] * view[ 5] + projection[11] * view[ 9] + projection[12] * view[13],
		projection[ 9] * view[ 2] + projection[10] * view[ 6] + projection[11] * view[10] + projection[12] * view[14],
		projection[ 9] * view[ 3] + projection[10] * view[ 7] + projection[11] * view[11] + projection[12] * view[15],
		projection[ 9] * view[ 4] + projection[10] * view[ 8] + projection[11] * view[12] + projection[12] * view[16],
		projection[13] * view[ 1] + projection[14] * view[ 5] + projection[15] * view[ 9] + projection[16] * view[13],
		projection[13] * view[ 2] + projection[14] * view[ 6] + projection[15] * view[10] + projection[16] * view[14],
		projection[13] * view[ 3] + projection[14] * view[ 7] + projection[15] * view[11] + projection[16] * view[15],
		projection[13] * view[ 4] + projection[14] * view[ 8] + projection[15] * view[12] + projection[16] * view[16]
	):transpose()

	--[[
	local clip = self.clip:set(
		view[ 1] * projection[ 1] + view[ 2] * projection[ 5] + view[ 3] * projection[ 9] + view[ 4] * projection[13],
		view[ 1] * projection[ 2] + view[ 2] * projection[ 6] + view[ 3] * projection[10] + view[ 4] * projection[14],
		view[ 1] * projection[ 3] + view[ 2] * projection[ 7] + view[ 3] * projection[11] + view[ 4] * projection[15],
		view[ 1] * projection[ 4] + view[ 2] * projection[ 8] + view[ 3] * projection[12] + view[ 4] * projection[16],
		view[ 5] * projection[ 1] + view[ 6] * projection[ 5] + view[ 7] * projection[ 9] + view[ 8] * projection[13],
		view[ 5] * projection[ 2] + view[ 6] * projection[ 6] + view[ 7] * projection[10] + view[ 8] * projection[14],
		view[ 5] * projection[ 3] + view[ 6] * projection[ 7] + view[ 7] * projection[11] + view[ 8] * projection[15],
		view[ 5] * projection[ 4] + view[ 6] * projection[ 8] + view[ 7] * projection[12] + view[ 8] * projection[16],
		view[ 9] * projection[ 1] + view[10] * projection[ 5] + view[11] * projection[ 9] + view[12] * projection[13],
		view[ 9] * projection[ 2] + view[10] * projection[ 6] + view[11] * projection[10] + view[12] * projection[14],
		view[ 9] * projection[ 3] + view[10] * projection[ 7] + view[11] * projection[11] + view[12] * projection[15],
		view[ 9] * projection[ 4] + view[10] * projection[ 8] + view[11] * projection[12] + view[12] * projection[16],
		view[13] * projection[ 1] + view[14] * projection[ 5] + view[15] * projection[ 9] + view[16] * projection[13],
		view[13] * projection[ 2] + view[14] * projection[ 6] + view[15] * projection[10] + view[16] * projection[14],
		view[13] * projection[ 3] + view[14] * projection[ 7] + view[15] * projection[11] + view[16] * projection[15],
		view[13] * projection[ 4] + view[14] * projection[ 8] + view[15] * projection[12] + view[16] * projection[16]
	):transpose()
	]]

	local RIGHT	= 0
	self[RIGHT + 1] = clip[ 4] - clip[ 1]
	self[RIGHT + 2] = clip[ 8] - clip[ 5]
	self[RIGHT + 3] = clip[12] - clip[ 9]
	self[RIGHT + 4] = clip[16] - clip[13]
	normalise(self, 0)

	local LEFT = 4
	self[LEFT + 1] = clip[ 4] + clip[ 1]
	self[LEFT + 2] = clip[ 8] + clip[ 5]
	self[LEFT + 3] = clip[12] + clip[ 9]
	self[LEFT + 4] = clip[16] + clip[13]
	normalise(self, 1)

	local BOTTOM = 8
	self[BOTTOM + 1] = clip[ 4] + clip[ 2]
	self[BOTTOM + 2] = clip[ 8] + clip[ 6]
	self[BOTTOM + 3] = clip[12] + clip[10]
	self[BOTTOM + 4] = clip[16] + clip[14]
	normalise(self, 2)

	local TOP = 12
	self[TOP + 1] = clip[ 4] - clip[ 2]
	self[TOP + 2] = clip[ 8] - clip[ 6]
	self[TOP + 3] = clip[12] - clip[10]
	self[TOP + 4] = clip[16] - clip[14]
	normalise(self, 3)

	local BACK = 16
	self[BACK + 1] = clip[ 4] - clip[ 3]
	self[BACK + 2] = clip[ 8] - clip[ 7]
	self[BACK + 3] = clip[12] - clip[11]
	self[BACK + 4] = clip[16] - clip[15]
	normalise(self, 4)

	local FRONT	= 20
	self[FRONT + 1] = clip[ 4] + clip[ 3]
	self[FRONT + 2] = clip[ 8] + clip[ 7]
	self[FRONT + 3] = clip[12] + clip[11]
	self[FRONT + 4] = clip[16] + clip[15]
	normalise(self, 5)

	return self
end

function frustum:pointInFrustum(x, y, z)
	for i = 0, 5 do
		local j = i * 4

		if self[j + 1] * x + self[j + 2] * y + self[j + 3] * z + self[j + 4] <= 0 then
			return false
		end
	end

	return true
end

function frustum:sphereInFrustum(x, y, z, radius)
	for i = 0, 5 do
		local j = i * 4

		if self[j + 1] * x + self[j + 2] * y + self[j + 3] * z + self[j + 4] <= -radius then
			return false
		end
	end

	return true
end

function frustum:cubeInFrustum(x, y, z, size)
	for i = 0, 5 do
		local j = i * 4

		if self[j + 1] * (x - size) + self[j + 2] * (y - size) + self[j + 3] * (z - size) + self[j + 4] > 0 then
			::continue::
		end

		if self[j + 1] * (x + size) + self[j + 2] * (y - size) + self[j + 3] * (z - size) + self[j + 4] > 0 then
			::continue::
		end

		if self[j + 1] * (x - size) + self[j + 2] * (y + size) + self[j + 3] * (z - size) + self[j + 4] > 0 then
			::continue::
		end

		if self[j + 1] * (x + size) + self[j + 2] * (y + size) + self[j + 3] * (z - size) + self[j + 4] > 0 then
			::continue::
		end

		if self[j + 1] * (x - size) + self[j + 2] * (y - size) + self[j + 3] * (z + size) + self[j + 4] > 0 then
			::continue::
		end

		if self[j + 1] * (x + size) + self[j + 2] * (y - size) + self[j + 3] * (z + size) + self[j + 4] > 0 then
			::continue::
		end

		if self[j + 1] * (x - size) + self[j + 2] * (y + size) + self[j + 3] * (z + size) + self[j + 4] > 0 then
			::continue::
		end

		if self[j + 1] * (x + size) + self[j + 2] * (y + size) + self[j + 3] * (z + size) + self[j + 4] > 0 then
			::continue::
		end

		return false
	end

	return true
end

function frustum:tostring(decimals)
	local s = ""

	for j = 0, 5 do
		for i = 0, 3 do
			s = s .. string.format("%." .. tostring(decimals or 2) .. "f, ", self[(j * 4 + i) + 1]) 
		end
		s = s .. "\n"
	end

	return s:sub(1, #s - 3)
end

function frustum:__tostring()
	return self:tostring(2)
end