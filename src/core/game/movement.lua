class.name = "movement"
class.base = "engine.monoBehaviour"

local mesh, material

function script:onLoad()
	local sh = engine.shader("assets/shaders/debug.glsl")
	material = engine.material(sh)

	mesh = engine.mesh("assets/meshes/cube.obj")
end

function class:awake()
	
end

function class:update(dt)
	local speed = 10.0

	if input:getKeyDown("escape") then
		love.event.quit()
	end

	if input:getKey("lshift") then
		speed = 100.0
	elseif input:getKey("lctrl") then
		speed = 1.0
	end

	if input:getKey("w") then
		self.transform.position = self.transform.position + self.transform.forward * dt * speed
	end

	if input:getKey("a") then
		self.transform.position = self.transform.position - self.transform.right * dt * speed
	end

	if input:getKey("d") then
		self.transform.position = self.transform.position + self.transform.right * dt * speed
	end

	if input:getKey("s") then
		self.transform.position = self.transform.position - self.transform.forward  * dt * speed
	end

	if input:getKey("space") then
		self.transform.position = self.transform.position + math.vector3(0, 1, 0) * dt * speed
	end

	if input:getKey("c") then
		self.transform.position = self.transform.position - math.vector3(0, 1, 0) * dt * speed
	end

	if input:getKey("left") then
		self.transform.rotation:rotate(0, 1, 0, dt)
	end

	if input:getKey("right") then
		self.transform.rotation:rotate(0, 1, 0, -dt)
	end

	if input:getMouseButton(1) then
		local gameObject = engine.gameObject()
		gameObject.transform.position:set(math.random() * 1000 - 500, math.random() * 1000 - 500, math.random() * 1000 - 500)
		local mr = gameObject:addComponent(engine.meshRenderer, mesh)
		mr:addMaterial(material)
	end

	local dx, dy = input:getMouseDelta()
	if math.abs(dx) > 0 then
		self.transform.rotation:rotate(0, 1, 0, -dt * dx)
	end
end