class.name = "engine.gameObject"
class.base = "engine.object"

local sceneManager, component, transform

function script:onLoad(env)
	sceneManager = engine.sceneManagement.sceneManager
	component = engine.component
	transform = engine.transform
end

function class:gameObject()
	class.base.object(self)

	self.layer = 1

	self.gameObject = self
	self.components = {}

	self:addComponent(transform)
	self.transform = self:getComponent(transform)
end

local function search(obj)
	return obj.instanceId
end

function class:addComponent(c, ...)
	if c then
		if c:typeof(component:type()) then
			local instance = setmetatable({}, c)

			instance.gameObject = self
			instance.transform  = self.transform

			--calls the constructor for class
			c[c:typename()](instance, ...)

			--prepare component for scene initialisation
			local scene = sceneManager:getActiveScene()
			table.insert(scene.queue, instance)

			--add component to gameObject for quicker reference
			local components = self.components[c:type()]

			if components == nil then
				components = {}; self.components[c:type()] = components
			end

			--store in order of instanceId for quicker reference when removing
			local obj, index = table.binarySearch(components, instance, search)
			table.insert(components, index + 1, table.reference(instance))

			return instance
		end
	end
end

function class:getComponent(c)
	if c then
		if c:typeof(component:type()) then
			local components = self.components[c:type()]
			if components ~= nil then
				return components[1]
			end
		end
	end
	
	return nil
end

function class:getComponents(c)
	if c then
		if c:typeof(component:type()) then
			local components = self.components[c:type()]
			if components ~= nil then
				return table.clone(components)
			end

			return {}
		end
	end
end