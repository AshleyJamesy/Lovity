import "lovity.core.container.array"
import "lovity.core.math.frustum"
import "lovity.core.math.matrix4"
import "lovity.core.engine.renderer"

base "lovity.core.engine.behaviour"

local insert = table.insert

local clear, newCanvas, pop, push, setCanvas, setDepthMode = 
	love.graphics.clear,
	love.graphics.newCanvas,
	love.graphics.pop,
	love.graphics.push,
	love.graphics.setCanvas,
	love.graphics.setDepthMode

local renderers

function class:loaded(packages)
	renderers = {}

	for _, pkg in pairs(packages) do
		if pkg.class ~= renderer and pkg.class:typeof(renderer:type()) then
			if type(pkg.class.draw) == "function" then
				insert(renderers, pkg.class:type())
			end
		end
	end
end

function camera:camera()
	super.behaviour(self)

	self.fov = math.rad(45)
	self.nearClip = 0.1
	self.farClip = 1000.0
	self.projection = matrix4():perspective(self.fov, love.graphics.getWidth() / love.graphics.getHeight(), self.nearClip, self.farClip)
	self.view = matrix4():identity()

	self.frustum = frustum(self.projection, self.view)

	self.buffers = {
		newCanvas(nil, nil, { format = "rgba32f" }),
		newCanvas(nil, nil, { format = "rgba32f" }),
		newCanvas(),
		newCanvas(),
		depthstencil = newCanvas(nil, nil, { format = "depth16", readable = true })
	}

	self.stats = {
		rendering = 0
	}

	self.__batches = {

	}

	if camera.main then
	else
		camera.main = self
	end
end

function camera:draw()
	local projection, view, frustum = 
		self.projection:perspective(self.fov, love.graphics.getWidth() / love.graphics.getHeight(), self.nearClip, self.farClip), 
		self.view:copy(self.transform.matrix):inverse(),
		self.frustum:calculate(self.projection, self.view)

	self.stats.rendering = 0

	local batches = self.__batches
	for material, batch in pairs(batches) do
		batch:empty()
	end

	for _, typename in pairs(renderers) do
		local list = self.scene.objects[typename]

		if list then
			for __, renderer in pairs(list) do
				if renderer:preDraw(self, frustum) then
					for ___, material in pairs(renderer.materials) do
						if batches[material] == nil then
							batches[material] = array()
						end

						batches[material]:add(renderer)

						self.stats.rendering = self.stats.rendering + 1
					end
				end
			end
		end
	end

	push("all")
	setCanvas(self.buffers)
	clear()
	setDepthMode("lequal", true)

	local shader, transform
	for material, batch in pairs(batches) do
		shader = material.shader

		if shader:hasUniform("uProjection") then
			shader:send("uProjection", self.projection)
		end

		if shader:hasUniform("uView") then
			shader:send("uView", self.view)
		end

		material:use()

		local model = shader:hasUniform("uModel")
		local modelInverse = shader:hasUniform("uModelInverse")

		local renderer 
		for i = 1, batch:size() do
			renderer = batch:get(i)

			transform = renderer.transform

			if model then
				shader:send("uModel", transform.matrix) --sends as row major even though matrix is column major due to 11.0 bug
			end

			if modelInverse then
				shader:send("uModelInverse", transform.matrixInverse) --sends as row major even though matrix is column major due to 11.0 bug
			end

			renderer:draw(self)
		end
	end

	pop()
end