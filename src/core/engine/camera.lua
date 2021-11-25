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
	self.nearClip = 0.1
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

local a = 0

function class:render()
	local scene = self.scene

	local projection = self.projection:perspective(self.fov, g.getWidth() / g.getHeight(), math.max(self.nearClip, 0.1),  math.max(self.farClip, 0.1))

	local view = self.transform.matrix:inverse()
	local frustum = self.frustum:calculate(projection, view)

	local properties = {
		{ 
			name = "projection",
			value = projection
		},
		{ 
			name = "view",
			value = view
		},
		{ 
			name = "viewPosition",
			value = self.transform.globalPosition:getTable()
		}
	}

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

	--stats
	self.stats.rendering = 0

	--construct render list
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

	g.setCanvas(self.buffers)
	g.clear()
	g.setDepthMode("lequal", true)

	local shader, transform
	for material, batch in pairs(batches) do
		shader = material.shader

		--sends all the properties for material
		material:use()

		--send all the default variables we need once
		for _, property in pairs(properties) do
			if shader:hasUniform(property.name) then
				shader:send(property.name, property.value)
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

		--should we send model and modelInverse for this material
		local model = shader:hasUniform("model")
		local modelInverse = shader:hasUniform("modelInverse")

		for _, renderer in pairs(batch) do
			transform = renderer.transform

			if model then
				--sends as row major even though matrix is column major due to 11.0 bug
				shader:send("model", transform.matrix) 
			end

			if modelInverse then
				--sends as row major even though matrix is column major due to 11.0 bug
				shader:send("modelInverse", transform.matrixInverse) 
			end

			renderer:render(self)
		end

		material:reset()
	end

	g.setColor(1.0, 1.0, 1.0, 1.0)
	g.setDepthMode()
	g.setMeshCullMode("none")
	g.setWireframe(false)
	g.setShader()
	g.setCanvas()
end