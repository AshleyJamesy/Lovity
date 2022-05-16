import "lovity.core.engine.input"

base "lovity.core.engine.monoBehaviour"

function movement:update(dt)
	local speed = 50.0

	if input:getKey("lshift") then
		speed = speed * 15.0
	end

	if input:getKey("w") then
		self.transform.position.x = self.transform.position.x + self.transform.forward.x * speed * dt
		self.transform.position.y = self.transform.position.y + self.transform.forward.y * speed * dt
		self.transform.position.z = self.transform.position.z + self.transform.forward.z * speed * dt
	end

	if input:getKey("a") then
		self.transform.position.x = self.transform.position.x - self.transform.right.x * speed * dt
		self.transform.position.y = self.transform.position.y - self.transform.right.y * speed * dt
		self.transform.position.z = self.transform.position.z - self.transform.right.z * speed * dt
	end

	if input:getKey("s") then
		self.transform.position.x = self.transform.position.x - self.transform.forward.x * speed * dt
		self.transform.position.y = self.transform.position.y - self.transform.forward.y * speed * dt
		self.transform.position.z = self.transform.position.z - self.transform.forward.z * speed * dt
	end

	if input:getKey("d") then
		self.transform.position.x = self.transform.position.x + self.transform.right.x * speed * dt
		self.transform.position.y = self.transform.position.y + self.transform.right.y * speed * dt
		self.transform.position.z = self.transform.position.z + self.transform.right.z * speed * dt
	end

	if input:getKey("space") then
		self.transform.position.y = self.transform.position.y + speed * 0.5 * dt
	end

	if input:getKey("lctrl") then
		self.transform.position.y = self.transform.position.y - speed * 0.5 * dt
	end
end