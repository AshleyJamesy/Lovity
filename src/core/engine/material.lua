class.name = "engine.material"

local graphics = love.graphics

function class:material(shader)
	self.shader = shader
	self.wireframe = false
	self.depthMode = "lequal"
	self.meshCullMode = "back"
	self.properties = {}
end

function class:setProperty(property, value)
	if self.shader:hasUniform(property:match("([A-Za-z0-9_]+)")) then
		self.properties[property] = value
	end
end

function class:getProperty(property)
	return self.properties[property]
end

function class:use()
	local shader = self.shader

	if shader then
		local properties = self.properties

		for name, property in pairs(shader:getUniforms()) do
			if properties[name] ~= nil then
				shader:send(name, properties[name])
			end
		end

		shader:use()

		if self.wireframe ~= graphics.isWireframe() then
			graphics.setWireframe(self.wireframe)
		end

		if self.depthMode ~= graphics.getDepthMode() then
			graphics.setDepthMode(self.depthMode, true)
		end

		if self.meshCullMode ~= graphics.getMeshCullMode() then
			graphics.setMeshCullMode(self.meshCullMode)
		end
	end
end

function class:reset()
	graphics.setColor(1.0, 1.0, 1.0, 1.0)
end