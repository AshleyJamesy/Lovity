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

		return frustum:sphereInFrustum(position.x, position.y, position.z, mesh.extent:magnitude() * math.max(math.max(scale.x, scale.y), scale.z))
	end

	return false
end

function class:render()
	graphics.setColor(self.colour)
	graphics.draw(self.mesh.source)
	graphics.setColor(1.0, 1.0, 1.0, 1.0)
end