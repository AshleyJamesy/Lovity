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

function class:addComponent(c, ...)
	if c then
		if c:typeof(component:type()) then
			local instance = setmetatable({}, c)

			instance.gameObject = self
			instance.transform  = self.transform

			c[c:typename()](instance, ...)

			local scene = sceneManager:getActiveScene()
			table.insert(scene.queue, #scene.queue + 1, instance)

			table.insert(self.components, 1, instance)

			return instance
		end
	end
end

function class:getComponent(c)
	if c then
		if c:typeof(component:type()) then
			for i = 1, #self.components do
				if self.components[i]:type() == c:type() then
					return self.components[i]
				end
			end
		end
	end
	
	return nil
end

function class:getComponents(component)
	if component then
		if typeof(component, "Component") then
			for i = 1, #self.components do
				if typeof(self.components[i], type(component)) then
					t[#t + 1] = self.components[i]
				end
			end
		end
	end
	
	return t
end