class.name = "rotate"
class.base = "engine.monoBehaviour"

function class:awake()
end

function class:update(dt)
	self.elapsed = self.elapsed + dt

	self.transform.position.x = math.sin(self.elapsed * 0.5) * 5
	self.transform.position.z = math.cos(self.elapsed * 0.5) * 5
end