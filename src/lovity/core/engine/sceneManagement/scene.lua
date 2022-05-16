import "lovity.core.container.allocator"
import "lovity.core.engine.component"
import "lovity.core.engine.transform"
import "lovity.core.engine.renderer"
import "lovity.core.engine.camera"

local hasValue = table.hasValue
local insert = table.insert
local search = table.search
local remove = table.remove

local callbacks = { update = {}, fixedupdate = {}, lateupdate = {} }

function class:loaded(packages)
	--once all classes are loaded,
	--get all classes which inherit from "component" and check if they have "update" or "lateupdate" methods
	for _, pkg in pairs(packages) do
		if pkg.class ~= component and pkg.class ~= transform and pkg.class:typeof(component:type()) then
			if type(pkg.class.update) == "function" then
				insert(callbacks.update, pkg.class:type())
			end

			if type(pkg.class.fixedupdate) == "function" then
				insert(callbacks.fixedupdate, pkg.class:type())
			end

			if type(pkg.class.lateupdate) == "function" then
				insert(callbacks.lateupdate, pkg.class:type())
			end
		end
	end
end

function scene:scene(name)
	self.name = name
	self.allocator = allocator()
	self.queue = {}
	self.objects = {}
	self.roots = {}

	return self
end

function scene:callFunctionOnType(list, typename, method, ...)
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
				local status, err = pcall(f, component, ...)
				if not status then
					print(err)
				end
			end

			index, component = next(batch, index)
		end	
	end
end

function scene:callFunctionOnAll(list, method, ignore, ...)
	for name, batch in pairs(list) do
		if ignore == nil then
			self:callFunctionOnType(list, name, method, ...)
		else
			if hasValue(ignore, name) then
			else
				self:callFunctionOnType(list, name, method, ...)
			end
		end
	end
end

function scene:fixedupdate(dt)
	for _, type in pairs(callbacks.fixedupdate) do
		self:callFunctionOnType(self.objects, type, "fixedupdate", dt)
	end
end

local function searchByInstanceId(obj)
	return obj.instanceId
end

function scene:update(dt)
	if #self.queue > 0 then
		--awake
		local status, err
		for _, component in pairs(self.queue) do
			if type(component.awake) == "function" then
				local status, err = pcall(component.awake, component)
				if not status then
					print(err)
				end
			end
		end

		--enable
		local status, err
		for _, component in pairs(self.queue) do
			if type(component.enable) == "function" then
				local status, err = pcall(component.enable, component)
				if not status then
					print(err)
				end
			end
		end

		--start
		local status, err
		for _, component in pairs(self.queue) do
			if type(component.start) == "function" then
				local status, err = pcall(component.start, component)
				if not status then
					print(err)
				end
			end
		end

		for i = #self.queue, 1, -1 do
			local component = remove(self.queue, #self.queue)
			local name = component:type()

			local objects = self.objects[name]

			if objects == nil then
				objects = {}; self.objects[name] = objects
			end

			local _, index = search(objects, component.instanceId, searchByInstanceId)
			insert(objects, index + 1, component)
		end
	end

	--transforms
	for _, transform in pairs(self.roots) do
		transform:update()
	end

	--all classes with "update" method
	for _, type in pairs(callbacks.update) do
		self:callFunctionOnType(self.objects, type, "update", dt)
	end

	--all classes with "lateupdate" method
	for _, type in pairs(callbacks.lateupdate) do
		self:callFunctionOnType(self.objects, type, "lateupdate")
	end
end

function scene:draw()
	self:callFunctionOnType(self.objects, camera:type(), "draw")
end