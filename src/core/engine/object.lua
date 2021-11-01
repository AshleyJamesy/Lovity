class.name = "engine.object"

local sceneManager

function script:onLoad(env)
	sceneManager = engine.sceneManagement.sceneManager
end

function class:object()
	self.scene = sceneManager:getActiveScene()

	local allocator = self.scene.allocator

	local id = allocator:get()
	if id == nil then
		id = allocator:add(allocator:count() + 1)
	end

	self.instanceId = id
	self.name = self:type()
end