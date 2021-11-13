class.name = "engine.meshRenderer"
class.base = "engine.renderer"

local graphics = love.graphics

function class:meshRenderer(mesh)
	class.base.renderer(self)

	self.colour = engine.colour(1.0, 1.0, 1.0, 1.0)
	self.mesh = mesh
end

function class:prerender(camera, frustum)
	local mesh = self.mesh

	if mesh then
		local scale, position = self.transform.scale, self.transform.globalPosition
		local radius = mesh.extent:magnitude() * math.max(math.max(scale.x, scale.y), scale.z)

		return frustum:sphereInFrustum(position.x, position.y, position.z, radius)
	end

	return false
end

function class:render()
	local meshes = self.mesh.meshes

	graphics.setColor(self.colour)

	for k, mesh in pairs(meshes) do
		graphics.draw(mesh)
	end

	graphics.setColor(1.0, 1.0, 1.0, 1.0)
end