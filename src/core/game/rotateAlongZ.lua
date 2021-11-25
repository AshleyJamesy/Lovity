class.name = "rotateAlongZ"
class.base = "engine.monoBehaviour"

function class:awake()
	self.meshRenderer = self.gameObject:getComponent(engine.meshRenderer)
	self.meshRenderer.colour:set(0.0, 0.0, 1.0, 1.0)
end

function class:update(dt)
	self.transform.rotation:rotate(0, 0, 1, dt)
end