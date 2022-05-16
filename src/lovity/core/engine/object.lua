import "lovity.core.engine.sceneManagement.sceneManager"

function object:object()
	self.scene = sceneManager:getActiveScene()

	local allocator = self.scene.allocator

	local id = allocator:get()
	if id == nil then
		id = allocator:add(allocator:count() + 1)
	end

	self.instanceId, self.name = id, self:type()

	return self
end