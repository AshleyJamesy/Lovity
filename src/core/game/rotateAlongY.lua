class.name = "rotateAlongY"
class.base = "engine.monoBehaviour"

function class:awake()
	self.meshRenderer = self.gameObject:getComponent(engine.meshRenderer)
	self.meshRenderer.colour:set(0.0, 1.0, 0.0, 1.0)
end

function class:update(dt)
	self.transform.rotation.y = self.transform.rotation.y + dt
end