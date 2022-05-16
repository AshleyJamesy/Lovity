base "lovity.core.engine.component"

function behaviour:behaviour()
	super.component(self)
	
	self.enabled = false

	return self
end

function behaviour:enable()
	if not self.enabled then
		self.enabled = true
		self:onEnable()
	end
end

function behaviour:disable()
	if self.enabled then
		self.enabled = false
		self:onDisable()
	end
end

--virtual functions
function behaviour:onEnable()
end

function behaviour:onDisable()
end