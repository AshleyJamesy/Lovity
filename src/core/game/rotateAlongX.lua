class.name = "rotateAlongX"
class.base = "engine.monoBehaviour"

function class:awake()
	self.meshRenderer = self.gameObject:getComponent(engine.meshRenderer)
	self.meshRenderer.colour:set(1.0, 0.0, 0.0, 1.0)
end

function class:update(dt)
	self.transform.rotation.x = self.transform.rotation.x + dt
end