class.name = "engine.camera"
class.base = "engine.behaviour"

local g = love.graphics

local renderers

function script:onLoad(env, classes)
	local renderer = engine.renderer

	renderers = {}

	for _, class in pairs(classes) do
		if class ~= renderer and class:typeof(renderer:type()) then
			if type(class.render) == "function" then
				table.insert(renderers, class:type())
			end
		end
	end
end

function class:camera()
	class.base.behaviour(self)

	self.buffers = {
		g.newCanvas(
			g.getWidth(),
			g.getHeight(),
			{ format = "rgba32f" }
		),
		g.newCanvas(
			g.getWidth(),
			g.getHeight(),
			{ format = "rgba32f" }
		),
		g.newCanvas(
			g.getWidth(),
			g.getHeight()
		),
		g.newCanvas(
			g.getWidth(),
			g.getHeight()
		),
		depthstencil = g.newCanvas(
			g.getWidth(),
			g.getHeight(),
			{ format = "depth16", readable = true }
		)
	}

	self.fov = math.rad(45)
	self.nearClip = 0.0
	self.farClip = 1000.0

	self.projection = math.matrix4():perspective(self.fov, g.getWidth() / g.getHeight(), self.nearClip, self.farClip)

	self.up = math.vector3(0, 1, 0)
	self.view = math.matrix4()

	self.frustum = math.frustum()
	self.frustum:calculate(self.projection, self.view)

	self.backgroundColour = engine.colour(0.5, 0.5, 1.0, 1)

	self.stats = {
		rendering = 0
	}

	if class.main then
	else
		class.main = self
	end
end

function class:render()
	local scene = self.scene

	local projection = self.projection:perspective(self.fov, g.getWidth() / g.getHeight(), self.nearClip, self.farClip)

	--TODO: view rotation
	local view = self.view:set(
		1, 0, 0, -self.transform.globalPosition.x,
		0, 1, 0, -self.transform.globalPosition.y,
		0, 0, 1, -self.transform.globalPosition.z,
		0, 0, 0, 1
	)

	local frustum = self.frustum
	frustum:calculate(projection, view)

	--stats
	self.stats.rendering = 0

	--render meshes in material batches
	local batches = {}
	for _, typename in pairs(renderers) do
		local list = self.scene.objects[typename]

		if list then
			for __, renderer in pairs(list) do
				for ___, material in pairs(renderer.materials) do
					if renderer:prerender(self, frustum) then
						if batches[material] == nil then
							batches[material] = {}
						end

						table.insert(batches[material], renderer)

						self.stats.rendering = self.stats.rendering + 1
					end
				end
			end
		end
	end

	--TODO: get closest lights to camera
	local lights = {}
	if scene.objects["engine.light"] ~= nil then
		for k, light in pairs(scene.objects["engine.light"]) do
			if light.enabled then
				if #lights < 4 then
					table.insert(lights, light)
				else
					break
				end
			end
		end
	end

	g.setCanvas(self.buffers)
	g.clear()
	g.setDepthMode("lequal", true)
	g.setMeshCullMode("back")

	local shader, transform

	local properties = {
		projection = projection,
		view = view,
		viewPosition = self.transform.globalPosition:getTable()
	}

	for material, batch in pairs(batches) do
		shader = material.shader

		--send all the default variables we need once,
		--before sending material properties
		for property, value in pairs(properties) do
			if shader:hasUniform(property) then
				shader:send(property, value)
			end
		end

		--send lights
		if shader:hasUniform("lights") then
			for k, light in pairs(lights) do
				light:send(shader, "lights[" .. (k - 1) .. "].")
			end

			for k = #lights + 1, 4 do
				engine.light.reset(shader, "lights[" .. (k - 1) .. "].")
			end
		end

		--sends all the properties for material
		material:use()

		--should we send model and modelInverse for this material
		local model = shader:hasUniform("model")
		local modelInverse = shader:hasUniform("modelInverse")

		for _, renderer in pairs(batch) do
			transform = renderer.transform

			if model then
				shader:send("model", transform.matrix)
			end

			if modelInverse then
				shader:send("modelInverse", transform.matrixInverse)
			end

			renderer:render(self)
		end

		material:reset()
	end

	g.setDepthMode()
	g.setMeshCullMode("none")
	g.setShader()
	g.setCanvas()
end