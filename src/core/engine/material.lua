class.name = "engine.material"

local exclude = {
	"projection",
	"view",
	"model",
	"modelInverse"
}

function class:material(shader)
	self.shader = shader
	self.wireframe = false
	self.properties = {}
end

function class:setProperty(property, value)
	if self.shader:hasUniform(property:match("([A-Za-z0-9_]+)")) then
		if not table.hasValue(exclude, property:match("([A-Za-z0-9_]+)")) then
			self.properties[property] = value
		end
	end
end

function class:getProperty(property)
	return self.properties[property]
end

function class:use()
	if self.shader then
		local properties = self.properties

		for name, property in pairs(self.shader:getUniforms()) do
			if not table.hasValue(exclude, name) then
				if properties[name] ~= nil then
					self.shader:send(name, properties[name])
				end
			end
		end

		self.shader:use()

		if self.wireframe ~= love.graphics.isWireframe() then
			love.graphics.setWireframe(self.wireframe)
		end
	end
end

function class:reset()
	if self.wireframe or love.graphics.isWireframe() then
		love.graphics.setWireframe(false)
	end
end