class.name = "engine.sceneManagement.scene"

local allocator, transform, component

local updaters = {}
local late_updaters = {}

function script:onLoad(env, classes)
	allocator = engine.allocator
	component = engine.component
	renderer = engine.renderer
	transform = engine.transform

	--once all scripts are loaded,
	--get all classes which inherit from "component" and check if they have "update" or "lateupdate" methods
	for _, class in pairs(classes) do
		if class ~= component and class ~= transform and class:typeof(component:type()) then
			if type(class.update) == "function" then
				table.insert(updaters, class:type())
			end

			if type(class.lateupdate) == "function" then
				table.insert(late_updaters, class:type())
			end
		end
	end
end

function class:scene(name)
	self.name = name
	self.allocator = allocator()
	self.queue = {}
	self.objects = {}
	self.roots = {}
end

function class:callFunctionOnType(list, typename, method, ...)
	local batch = list[typename]

	if batch then
		local f = nil

		local index, component = next(batch, nil)
		local status, err

		while index do
			if f == nil then
				f = component[method]

				if f == nil or type(f) ~= "function" then
					f = nil
					break
				end
			end

			if component.enabled == nil or component.enabled == true then
				--BUILD
				--pcall(f, component, ...)

				--EDITOR
				status, err = pcall(f, component, ...)
				if not status then
					print(ansicolour.option.reset .. ansicolour.option.bright .. ansicolour.colour.red .. typename .. ": " .. method .. " - " .. err .. ansicolour.option.reset)
				end
			end

			index, component = next(batch, index)
		end	
	end
end

function class:callFunctionOnAll(list, method, ignore, ...)
	for name, batch in pairs(list) do
		if ignore == nil then
			self:callFunctionOnType(list, name, method, ...)
		else
			if table.hasValue(ignore, name) then
			else
				self:callFunctionOnType(list, name, method, ...)
			end
		end
	end
end

local function search(obj)
	return obj.instanceId
end

--TODO: remove status, err for build
--no need to pcall if not debugging
function class:update(dt)
	input:update()

	if #self.queue > 0 then
		--awake
		local status, err
		for _, component in pairs(self.queue) do
			if type(component.awake) == "function" then
				--BUILD
				pcall(component.awake, component)

				--EDITOR
				--[[
					status, err = pcall(component.awake, component)
					if not status then
						print(ansicolour.option.reset .. ansicolour.option.bright .. ansicolour.colour.red .. err .. ansicolour.option.reset)
					end
				]]
			end
		end

		--enable
		local status, err
		for _, component in pairs(self.queue) do
			if type(component.enable) == "function" then
				--BUILD
				pcall(component.enable, component)

				--EDITOR
				--[[
					status, err = pcall(component.enable, component)
					if not status then
						print(ansicolour.option.reset .. ansicolour.option.bright .. ansicolour.colour.red .. err .. ansicolour.option.reset)
					end
				]]
			end
		end

		--start
		local status, err
		for _, component in pairs(self.queue) do
			if type(component.start) == "function" then
				--BUILD
				pcall(component.start, component)

				--EDITOR
				--[[
					status, err = pcall(component.start, component)
					if not status then
						print(ansicolour.option.reset .. ansicolour.option.bright .. ansicolour.colour.red .. err .. ansicolour.option.reset)
					end
				]]
			end
		end

		for i = #self.queue, 1, -1 do
			local component = table.remove(self.queue, #self.queue)
			local name = component:type()

			local objects = self.objects[name]

			if objects == nil then
				objects = {}; self.objects[name] = objects
			end

			--store in order of instanceId for quicker reference when removing
			local _, index = table.binarySearch(objects, component, search)
			table.insert(objects, index + 1, component)
		end
	end

	--transforms
	for _, transform in pairs(self.roots) do
		transform:update()
	end

	--all classes with "update" method
	for _, type in pairs(updaters) do
		self:callFunctionOnType(self.objects, type, "update", dt)
	end

	--all classes with "lateupdate" method
	for _, type in pairs(updaters) do
		self:callFunctionOnType(self.objects, type, "lateupdate")
	end

	input:lateupdate()
end

function class:render()
	self:callFunctionOnType(self.objects, engine.camera:type(), "render")
end