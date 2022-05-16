base "lovity.core.engine.component"

local insert = table.insert

function renderer:renderer()
	super.component(self)

	self.materials = {}

	return self
end

function renderer:addMaterial(material)
	insert(self.materials, material)
end

function renderer:preDraw(camera, frustum)
	return true
end

function renderer:draw()
end