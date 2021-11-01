class.name = "moveAlongX"
class.base = "engine.monoBehaviour"

function class:awake()
	self.elapsed = 0.0

	self.start = self.transform.position.x

	self.meshRenderer = self.gameObject:getComponent(engine.meshRenderer)
	self.meshRenderer.colour:set(1.0, 0.0, 0.0, 1.0)
end

function class:update(dt)
	self.elapsed = self.elapsed + dt

	self.transform.position.x = self.start + math.sin(self.elapsed * 0.5) * 5
end