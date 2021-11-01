class.name = "engine.behaviour"
class.base = "engine.component"

function class:behaviour()
	class.base.component(self)

	self.enabled = false
end

function class:enable()
	if not self.enabled then
		self.enabled = true
		self:onEnable()
	end
end

function class:disable()
	if self.enabled then
		self.enabled = false
		self:onDisable()
	end
end

--virtual functions
function class:onEnable()
end

function class:onDisable()
end