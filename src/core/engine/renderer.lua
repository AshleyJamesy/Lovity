class.name = "engine.renderer"
class.base = "engine.component"

function class:renderer()
	class.base.component(self)
	
	self.sortingOrder = 1
	self.materials = {}
end

function class:addMaterial(material)
	table.insert(self.materials, material)
end

function class:prerender(camera, frustum)
	return true
end

function class:render()
end