class.name = "engine.transform"
class.base = "engine.component"

function class:transform()
	class.base.component(self)

	self.parent = nil
	self.children = {}

	self.scale = math.vector3(1, 1, 1)
	self.rotation = math.vector3(0, 0, 0)
	self.position = math.vector3(0, 0, 0)

	self.globalScale = math.vector3(1, 1, 1)
	self.globalRotation = math.vector3(0, 0, 0)
	self.globalPosition = math.vector3(0, 0, 0)

	self.left = math.vector3(0, 0, 0)
	self.up = math.vector3(0, 0, 0)
	self.forward = math.vector3(0, 0, 0)

	self.matrix = math.matrix4()
	self.matrixInverse = math.matrix4()

	table.insert(self.gameObject.scene.roots, self)
end

function class:update()
	local scale, rotation, position = self.scale, self.rotation, self.position

	self.matrix:transform(scale.x, scale.y, scale.z, position.x, position.y, position.z, rotation.x, rotation.y, rotation.z)

	if self.parent ~= nil then
		self.matrix = self.parent.matrix * self.matrix
	end

	local matrix = self.matrix

	self.globalPosition:set(matrix:getPosition())

	self.up:set(matrix:getUp())
	self.forward:set(matrix:getForward())
	self.left:set(matrix:getLeft())

	self.matrixInverse = self.matrixInverse:copy(self.matrix):inverse():transpose()

	for _, child in pairs(self.children) do
		child:update()
	end
end

function class:addChild(child)
	if self == child then 
		return
	end

	if self.children[child.instanceId] then 
		return
	end

	if child.parent then
		child.parent.children[child.instanceId] = nil
	else
		local j = 0
		for k, v in pairs(child.gameObject.scene.roots) do
			if v == child then
				j = k
				break
			end
		end
		
		table.remove(child.gameObject.scene.roots, j)
	end

	child.parent = self

	self.children[child.instanceId] = child
end

function class:removeChild(child)
	if self == child then 
		return
	end

	if not self.children[child.instanceId] then 
		return
	end

	self.children[child.instanceId] = nil
	child.parent = nil

	local j = 0
	for k, v in pairs(child.gameObject.scene.roots) do
		if v == child then
			j = k
			break
		end
	end

	if j > 0 then
	else
		table.insert(child.gameObject.scene.roots, child)
	end
end