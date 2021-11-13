class.name = "spin"
class.base = "engine.monoBehaviour"

function class:awake()
end

function class:update(dt)
	self.transform.rotation.y = self.transform.rotation.y + dt * 0.1
end