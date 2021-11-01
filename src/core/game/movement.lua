class.name = "movement"
class.base = "engine.monoBehaviour"

function class:awake()
	
end

function class:update(dt)
	local speed = 10.0

	if love.keyboard.isDown("lshift") then
		speed = 50.0
	elseif love.keyboard.isDown("lctrl") then
		speed = 1.0
	end

	if love.keyboard.isDown("w") then
		self.transform.position = self.transform.position + self.transform.forward * dt * speed
	end

	if love.keyboard.isDown("a") then
		self.transform.position = self.transform.position + self.transform.left * dt * speed
	end

	if love.keyboard.isDown("d") then
		self.transform.position = self.transform.position - self.transform.left * dt * speed
	end

	if love.keyboard.isDown("s") then
		self.transform.position = self.transform.position - self.transform.forward  * dt * speed
	end

	if love.keyboard.isDown("space") then
		self.transform.position = self.transform.position + math.vector3(0, 1, 0) * dt * speed
	end

	if love.keyboard.isDown("c") then
		self.transform.position = self.transform.position - math.vector3(0, 1, 0) * dt * speed
	end
end