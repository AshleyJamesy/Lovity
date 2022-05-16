import "lovity.core.engine.colour"

base "lovity.core.engine.renderer"

local draw = love.graphics.draw

function meshRenderer:meshRenderer(mesh)
	super.renderer(self)

	self.mesh = mesh

	return self
end

function meshRenderer:preDraw(camera, frustum)
	local position = self.transform.globalPosition

	return frustum:sphereInFrustum(position.x, position.y, position.z, 1.0)
end

function meshRenderer:draw()
	if self.mesh ~= nil then
		for _, mesh in pairs(self.mesh.meshes) do
			draw(mesh)
		end
	end
end