class.name = "spin"
class.base = "engine.monoBehaviour"

function class:awake()
	self.time = 0.0
end

function class:update(dt)
	self.time = self.time + dt

	self.transform.rotation:rotate(1, 1, 0, dt)
end