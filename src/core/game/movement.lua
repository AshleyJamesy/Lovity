class.name = "movement"
class.base = "engine.monoBehaviour"

function class:awake()
	
end

function class:update(dt)
	local speed = 10.0

	if input:getKeyDown("escape") then
		love.event.quit()
	end

	if input:getKey("lshift") then
		speed = 50.0
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

	if input:getKeyDown("g") then
		collectgarbage()
	end
end