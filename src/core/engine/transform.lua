class.name = "engine.transform"
class.base = "engine.component"

function class:transform()
	class.base.component(self)

	self.parent = nil
	self.children = {}

	self.scale = math.vector3(1, 1, 1)
	self.rotation = math.quaternion(0, 0, 0, 1)
	self.position = math.vector3(0, 0, 0)

	self.globalScale = math.vector3(1, 1, 1)
	self.globalRotation = math.vector3(0, 0, 0)
	self.globalPosition = math.vector3(0, 0, 0)

	self.right = math.vector3(0, 0, 0)
	self.up = math.vector3(0, 0, 0)
	self.forward = math.vector3(0, 0, 0)

	self.matrix = math.matrix4()
	self.matrixInverse = math.matrix4()
	self.rotationMatrix = math.matrix4()

	table.insert(self.gameObject.scene.roots, self) --optimise to insert in order of instanceId
end

function class:update()
	local scale, rotation, position = self.scale, self.rotation, self.position

	--TODO: optimise + rotation
	--[[
		add transformation function in math.matrix4 class
	]]
	local matrix = self.matrix:set(
		scale.x, 0, 0, position.x,
		0, scale.y, 0, position.y,
		0, 0, scale.z, position.z,
		0, 0, 0, 1
	)

	if self.parent ~= nil then
		matrix:set(
			math.matrix4.multiply(self.parent.matrix, self.matrix)
		)
	end

	self.matrixInverse = self.matrixInverse:copy(matrix):inverse()

	self.globalPosition:set(matrix[4], matrix[8], matrix[12])

	self.right:set(matrix[1], matrix[5], matrix[9])
	self.up:set(matrix[2], matrix[6], matrix[10])
	self.forward:set(-matrix[3], -matrix[7], -matrix[11])

	for _, child in pairs(self.children) do
		child:update()
	end
end

--TODO: optimise transform children
--[[
	transforms do not care what order children are updated in,
	so instead of looping through all children looking for instanceId already exists
	we can insert in order and then find the child based on instanceId using binary searches
]]
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

--TODO: optimise transform children
--[[
	transforms do not care what order children are updated in,
	so instead of looping through all children looking for instanceId to remove
	We ensure ordered list by instanceId and find the child using binary searches
]]
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