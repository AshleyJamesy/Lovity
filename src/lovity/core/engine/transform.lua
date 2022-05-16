import "lovity.core.math.matrix4"
import "lovity.core.math.quaternion"
import "lovity.core.math.vector3"

base "lovity.core.engine.component"

local insert = table.insert
local search = table.search
local remove = table.remove

local function searchByInstanceId(obj)
	return obj.instanceId
end

function transform:transform()
	super.component(self)

	self.parent, self.children = nil, {}

	self.scale = vector3(1, 1, 1)
	self.rotation = quaternion(0, 0, 0, 1)
	self.position = vector3(0, 0, 0)

	self.globalPosition = vector3(0, 0, 0)

	self.right = vector3(0, 0, 0)
	self.up = vector3(0, 0, 0)
	self.forward = vector3(0, 0, 0)

	self.matrix = matrix4()
	self.matrixInverse = matrix4()

	self:update()

	if self.gameObject.static ~= true then
		local obj, index = search(self.scene.roots, self.instanceId, searchByInstanceId)
		insert(self.scene.roots, index + 1, self)
	end

	return self
end

local scale, rotation, position

function transform:update()
	scale, rotation, position = self.scale, self.rotation, self.position

	local matrix = self.matrix:transform(scale.x, scale.y, scale.z, position.x, position.y, position.z, rotation.x, rotation.y, rotation.z, rotation.w)

	if self.parent ~= nil then
		matrix:set(
			math.matrix4.multiply(self.parent.matrix, self.matrix)
		)
	end

	self.matrixInverse = self.matrixInverse:copy(matrix):inverse()

	self.globalPosition:set(matrix[4], matrix[8], matrix[12])

	self.forward:set(-matrix[3], -matrix[7], -matrix[11])
	self.right:set(math.cross(self.forward.x, self.forward.y, self.forward.z, 0.0, 1.0, 0.0))
	self.up:set(math.cross(self.right.x, self.right.y, self.right.z, self.forward.x, self.forward.y, self.forward.z))

	for _, child in pairs(self.children) do
		child:update()
	end
end

function transform:addChild(child)
	if self == child then return end
	if self.children[child.instanceId] then return end

	if child.parent then
		child.parent.children[child.instanceId] = nil
	else
		local obj, index = search(child.gameObject.scene.roots, child.instanceId, searchByInstanceId)
		if obj ~= nil then
			remove(child.gameObject.scene.roots, index)
		end
	end

	child.parent = self

	self.children[child.instanceId] = child
end

function transform:removeChild(child)
	if self == child then return end
	if not self.children[child.instanceId] then return end

	self.children[child.instanceId] = nil
	child.parent = nil

	local obj, index = search(child.gameObject.scene.roots, child.instanceId, searchByInstanceId)
	if obj == nil then
		insert(child.gameObject.scene.roots, index + 1, child)
	end
end