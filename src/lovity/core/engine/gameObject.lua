import "lovity.core.engine.sceneManagement.sceneManager"
import "lovity.core.engine.component"
import "lovity.core.engine.transform"

base "lovity.core.engine.object"

local copy = table.copy
local insert = table.insert
local search = table.search
local setmetatable = setmetatable
local reference = table.reference

function gameObject:gameObject()
	super.object(self)

	self.gameObject = self
	self.components = {}

	self:addComponent(transform)
	self.transform = self:getComponent(transform)

	return self
end

local function searchByInstanceId(obj)
	return obj.instanceId
end

function gameObject:addComponent(c, ...)
	if c then
		if c:typeof(component:type()) then
			local instance = setmetatable({}, c)

			instance.gameObject, instance.transform = self, self.transform

			--calls the constructor for class
			c[c:typename()](instance, ...)

			--prepare component for scene initialisation
			local scene = sceneManager:getActiveScene()
			insert(scene.queue, instance)

			--add component to gameObject for quicker reference
			local components = self.components[c:type()]

			if components == nil then
				components = {}; self.components[c:type()] = components
			end

			--store in order of instanceId for quicker reference when removing
			local obj, index = search(components, instance.instanceId, searchByInstanceId)

			--use table reference with so if deleted it is garbage collected and not held by scripts
			insert(components, index + 1, reference(instance)) 

			return instance
		end
	end
end

function gameObject:getComponent(c)
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

function gameObject:getComponents(c)
	if c then
		if c:typeof(component:type()) then
			local components = self.components[c:type()]
			if components ~= nil then
				return copy(components)
			end

			return {}
		end
	end
end