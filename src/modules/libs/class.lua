local scripts = {}

local mt_script = { 
	__index = _G, __newindex = _G
}

local function valid(name)
	if type(name) == "string" then
		if not string.match(name, "^[a-zA-Z.]+[0-9]*$") then
			if not string.match(name, "^[a-zA-Z]") then
				return false, "must start with an alpha character"
			end

			if string.match(name, "^.*%.$") then
				return false, "must not end with period"
			end

			if string.find(name, "%s") then
				return false, "must not contain whitespace"
			end

			return false, "must be alphanumeric without whitespaces"
		end
	else
		return false, "must be a string"
	end

	return true
end

local function namespaces(name)
	local t = {}

	for word in (name .. "."):gmatch("(.-)" .. "%.") do 
		table.insert(t, word)
	end

	return t, table.remove(t)
end

local function load_env(path, env)
	local info = love.filesystem.getInfo(path)

	if info then
		if info.type == "file" then
			env = setmetatable(env or {}, mt_script)

			local chunk, err
			
			if love.system.getOS() == "Android" then
				local contents, size = love.filesystem.read(path)
				
				if contents ~= nil then
					chunk, err = loadstring(contents)
				else
					return 2, size
				end
			else
				chunk, err = loadfile(path)
			end

			if not chunk then
				return 2, "compile error: " .. err
			else
				setfenv(chunk, env)

				local success, err = pcall(chunk)
				if not success then
					return 3, "compile error: " .. err
				end
			end
		else
			if info.type == "directory" then
			else
				return 1, "does not exist"
			end
		end
	else
		return 1, "does not exist"
	end

	return 0
end

local function script_load(path)
	local info = love.filesystem.getInfo(path)

	if info then
		if info.type == "directory" then
			path = path .. (path:sub(-#"/") ~= "/" and "/" or "")

			local files = love.filesystem.getDirectoryItems(path)

			for _, filename in pairs(files) do
				script_load(path .. filename)
			end
		end

		if info.type == "file" then
			if path:sub(-#".lua") ~= ".lua" then
				return
			end

			for _, script in pairs(scripts) do
				if path == script.path then
					error(path .. " - " .. "compile error: <" .. script.class.name .. "> already loaded", 5)
				end
			end

			local script = {
				compiled = false, path = path
			}

			local env = {
				script = script, class = {}
			}

			local status, err = load_env(path, env)

			if status ~= 0 then
				error(path .. " - " .. err, 5)
			end

			local class = env.class

			if class.name ~= nil then
				local status, err = valid(class.name)

				if not status then
					error(path .. " - " .. "compile error: class name " .. err, 5)
				end

				if scripts[class.name] then
					error(path .. " - " .. "compile error: <" .. class.name .. "> already exists at: " .. scripts[class.name].path, 5)
				end
			else
				error(path .. " - " .. "compile error: missing class name", 5)
			end

			local spaces, className = namespaces(class.name)

			--reserved keywords
			if class.base == nil then
				if type(class[className]) ~= "function" then
					if type(class[className]) == "nil" then
						error(path .. " - " .. "compile error: <" .. class.name .. "> missing constructor", 5)
					end

					error(path .. " - " .. "compile error: <" .. class.name .. "> constructor must be function", 5)
				end

				if type(class.init) ~= "function" then
					if type(class.init) ~= "nil" then
						error(path .. " - " .. "compile error: <" .. class.name .. "> 'init' constructor must be function", 5)
					end
				end
			else
				local status, err = valid(class.base)

				if not status then
					error(path .. " - " .. "compile error: base class name " .. err, 5)
				end
			end

			local mt_class = {
				__call = function(t, ...)
					if t.init then
						return t.init(t, ...)
					end

					local o = setmetatable({}, t)
					o[className](o, ...)

					return o
				end
			}

			setmetatable(class, mt_class)

			script.classname 	= class.name
			script.class 		= class
			script.basename 	= class.base
			script.baseclass 	= baseclass
			script.types 		= { class.name }

			class.__index = class

			class.type = function(self)
				return script.classname
			end

			class.typename = function(self)
				return className
			end

			class.typeof = function(self, target)
				if type(target) ~= "string" then
					return false
				end

				for _, class_type in pairs(script.types) do
					if class_type == target then
						return true
					end
				end

				return false
			end

			script.class.name = nil
			script.class.requires = nil

			scripts[script.classname] = script
		end
	end
end

local function script_compile(script, env)
	if script.compiled then
	else
		if script.basename ~= nil then
			local script_base = scripts[script.basename]

			if script_base then
				if not script_base.compiled then
					script_compile(script_base, env)
				end

				local _, className = namespaces(script.classname)
				local _, baseClassName = namespaces(script_base.classname)

				--copy the functions to new class, except for the constructor
				for member, value in pairs(script_base.class) do
					if member ~= baseClassName then
						if rawget(script.class, member) then
						else
							rawset(script.class, member, value)
						end
					end
				end

				--if the new class does not have a constructor, copy the one from base class
				if rawget(script.class, className) then
				else
					local value = rawget(script_base.class, baseClassName)
					if type(value) == "function" then
						rawset(script.class, className, value)
					end
				end

				script.class.base = script_base.class

				script.compiled = true
				script.baseclass = script_base.class

				for _, type in pairs(script_base.types) do
					table.insert(script.types, type)
				end
			else
				error(script.path .. " - compile error: <" .. script.basename .. "> unresolved class", 5)
			end
		end

		local lib = env
		local spaces, classname = namespaces(script.classname)

		if #spaces > 0 then
			for k, namespace in pairs(spaces) do
				if lib[namespace] == nil then
					lib[namespace] = {}
				end

				if type(lib[namespace]) ~= "table" then
					error(script.path .. " - compile error: <" .. script.classname .. "> unable to compile to namespace<".. k .. ":" .. namespace .. ">' is not of type table", 5)
				end

				lib = lib[namespace]
			end
		end

		script.compiled = true
		lib[classname] = script.class
	end
end

local function compile(path, env)
	if type(env) ~= "table" then
		error("environment not provided", 2)
	end

	local info = love.filesystem.getInfo(path)

	if info then
		if info.type == "file" or info.type == "directory" then
			script_load(path)
		end
	end

	for _, script in pairs(scripts) do
		script_compile(script, env)
	end

	local classes = {}
	for _, script in pairs(scripts) do
		table.insert(classes, script.class)
	end

	for _, script in pairs(scripts) do
		if type(script.onLoad) == "function" then
			script:onLoad(env, classes)
		end
	end

	return env
end

return {
	compile = compile
}