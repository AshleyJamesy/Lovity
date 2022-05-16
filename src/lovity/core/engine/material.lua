local getDepthMode, setDepthMode, getMeshCullMode, setMeshCullMode = 
	love.graphics.getDepthMode,
	love.graphics.setDepthMode,
	love.graphics.getMeshCullMode,
	love.graphics.setMeshCullMode

local iNoImage = love.graphics.newImage(love.
	image.newImageData(1,1,"rgba8", "\xFF\xFF\xFF\xFF")
)

function material:material(shader)
	self.shader = shader
	self.depthMode = "lequal"
	self.meshCullMode = "back"
	self.properties = {}

	return self
end

function material:setProperty(name, value)
	if self.shader:hasUniform(name:match("([A-Za-z0-9_]+)")) then
		self.properties[name] = value
	end
end

function material:getProperty(property)
	return self.properties[property]
end

function material:use()
	local shader = self.shader

	if shader then
		local properties = self.properties

		for name, value in pairs(properties) do
			if value ~= nil then
				self.shader:send(name, value)
			else
				local type = self.shader:getUniformType(name)
				
				if type == "sampler2D" or type == "Image" then
					self.shader:send(name, iNoImage)
				end
			end
		end

		shader:use()

		if self.depthMode ~= getDepthMode() then
			setDepthMode(self.depthMode, true)
		end

		if self.meshCullMode ~= getMeshCullMode() then
			setMeshCullMode(self.meshCullMode)
		end
	end
end