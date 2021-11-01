class.name = "engine.light"
class.base = "engine.behaviour"

function class:light()
	self.colour = engine.colour()
	self.strength = 2.0
end

function class:send(shader, uniform)
	shader:send(uniform .. "position", self.transform.globalPosition:getTable())
	shader:send(uniform .. "colour", self.colour)
	shader:send(uniform .. "strength", self.strength)
end

local position = { 0, 0, 0 }
local colour = { 0, 0, 0, 0 }

function class.reset(shader, uniform)
	shader:send(uniform .. "position", position)
	shader:send(uniform .. "colour", colour)
	shader:send(uniform .. "strength", 0.0)
end