# Lovity
A 3d unity like engine made with Love2d

# Features

## Game Object and Components
```lua
local gameObject = engine.gameObject()
local meshRenderer = gameObject:addComponent(engine.meshRenderer)
meshRenderer.mesh = mesh
meshRenderer:addMaterial(material)
```
## Models (.obj)
```lua
engine.model("assets/models/obj.obj")
```
## Materials
```lua
engine.material("assets/shaders/material.glsl")
```
## Dynamic Lighting
```lua
local gameObject = engine.gameObject()
local light = gameObject:addComponent(engine.light)
light.colour:set(1.0, 0.0, 0.0, 1.0)
```
## Camera Frustum Culling
Greatly improves performance by only rendering what the camera can see

## Robust Class System
**Example:** Mesh Renderer
```lua
class.name = "engine.meshRenderer"
class.base = "engine.renderer"

local graphics = love.graphics

function class:meshRenderer(mesh)
	class.base.renderer(self)

	self.colour = engine.colour(1.0, 1.0, 1.0, 1.0)
	self.mesh = mesh
end

function class:prerender(camera, frustum)
	local mesh = self.mesh

	if mesh then
		local scale, position = self.transform.scale, self.transform.globalPosition

		return frustum:sphereInFrustum(position.x, position.y, position.z, mesh.extent:magnitude() * math.max(math.max(scale.x, scale.y), scale.z))
	end

	return false
end

function class:render()
	graphics.setColor(self.colour)
	graphics.draw(self.mesh.source)
	graphics.setColor(1.0, 1.0, 1.0, 1.0)
end
```

**Example:** Movement Class
```lua
class.name = "movement"
class.base = "engine.monoBehaviour"

function class:awake()
	self.speed = 10.0
end

function class:start()
	
end

function class:update(dt)
	if love.keyboard.isDown("lshift") then
		self.speed = 50.0
	elseif love.keyboard.isDown("lctrl") then
		self.speed = 1.0
	else
		self.speed = 10.0
	end

	if love.keyboard.isDown("w") then
		self.transform.position = self.transform.position + self.transform.forward * dt * self.speed
	end

	if love.keyboard.isDown("a") then
		self.transform.position = self.transform.position + self.transform.left * dt * self.speed
	end

	if love.keyboard.isDown("d") then
		self.transform.position = self.transform.position - self.transform.left * dt * self.speed
	end

	if love.keyboard.isDown("s") then
		self.transform.position = self.transform.position - self.transform.forward  * dt * self.speed
	end

	if love.keyboard.isDown("space") then
		self.transform.position = self.transform.position + math.vector3(0, 1, 0) * dt * self.speed
	end

	if love.keyboard.isDown("c") then
		self.transform.position = self.transform.position - math.vector3(0, 1, 0) * dt * self.speed
	end
end
```
