local match = string.match
local insert = table.insert
local remove = table.remove

local function deconstruct(classpath)
	local t = {}

	for word in (classpath .. "."):gmatch("(.-)" .. "%.") do 
		insert(t, word)
	end

	return t, remove(t)
end

local function loadstring_env(contents, env)
	local chunk, err = loadstring(contents)

	if chunk == nil then
		return false, err:gsub("^%[.*%]", "")
	else
		setfenv(chunk, env)

		local ok, err = pcall(chunk)
		if not ok then
			return false, err:gsub("^%[.*%]", "")
		end
	end

	return true
end

local function compile(packages, pkg)
	if pkg.compiled == true then
		return true
	end

	for _, pkga in pairs(packages) do
		local env = pkg.env

		local pkgs, classname = deconstruct(pkga.classpath)
		for _, pkg_name in pairs(pkgs) do
			if env[pkg_name] == nil then
				env[pkg_name] = {}
			end

			env = env[pkg_name]
		end

		env[classname] = pkga.class
	end

	--imports
	for _, classpath in pairs(pkg.imports) do
		local pkgs, basename = deconstruct(classpath)

		local env = pkg.env
		for _, pkg_name in pairs(pkgs) do
			if env[pkg_name] ~= nil then
				env = env[pkg_name]
			else
				return false, pkg.filepath .. ": cannot resolve symbol '" .. pkg_name .. "'"
			end
		end

		if basename == "*" then
			for pkg_name, pkga in pairs(env) do
				pkg.env[pkg_name] = pkga
			end
		else
			if packages[classpath] ~= nil then
				if pkg.env[basename] == nil then
					pkg.env[basename] = packages[classpath].class
				end
			else
				return false, pkg.filepath .. ": unresolved type <" .. classpath .. ">"
			end
		end
	end

	--base class
	if pkg.basename ~= nil then
		local pkg_base = packages[pkg.basename]

		if pkg_base ~= nil then
			if not pkg_base.compiled then
				local ok, err = compile(packages, pkg_base)

				if not ok then
					return false, err
				end
			end

			--copy the base class functions to class, except for the base constructor
			for member, value in pairs(pkg_base.class) do
				if member ~= pkg_base.classname then
					if rawget(pkg.class, member) == nil then
						rawset(pkg.class, member, rawget(pkg_base.class, member))
					end
				end
			end

			--copy the constructor from base class if we don't have one
			if rawget(pkg.class, pkg.classname) == nil then
				rawset(pkg.class, pkg.classname, rawget(pkg_base.class, pkg_base.classname))
			end

			--copy types to our class
			for _, classpath in pairs(pkg_base.types) do
				insert(pkg.types, classpath)
			end

			pkg.env.super = pkg_base.class
		else
			return false, pkg.filepath .. ": unresolved type <" .. pkg.basename .. ">"
		end
	end

	setmetatable(pkg.env, { __index = _G, __newindex = _G })

	pkg.class.__index = pkg.class

	--make the class table callable for contructor
	if type(rawget(pkg.class, pkg.classname)) == "function" then
		setmetatable(pkg.class, {
			__call = function(t, ...)
				return pkg.class[pkg.classname](setmetatable({}, pkg.class), ...)
			end
		})
	end

	pkg.class.type = function()
		return pkg.classpath
	end

	pkg.class.typename = function()
		return pkg.classname
	end

	pkg.class.typeof = function(tbl, other)
		for _, classpath in pairs(pkg.types) do
			if classpath == other then
				return true
			end
		end

		return false
	end

	pkg.compiled = true

	return true
end

local function load(path)
	local packages = {}

	for _, path in pairs(path:explode(";")) do
		if not path:endsWith("/") then
			path = path .. "/"
		end

		local files, queue = {}, { path }

		while #queue > 0 do
			local folder = queue[1]

			local list = love.filesystem.getDirectoryItems(folder)
			for _, filename in pairs(list) do
				local info = love.filesystem.getInfo(folder .. filename)
				if info then
					if info.type == "file" then
						if filename:endsWith(".lua") then
							insert(files, folder .. filename)
						end
					elseif info.type == "directory" then
						insert(queue, queue[1] .. filename .. "/")
					end
				end
			end

			remove(queue, 1)
		end

		for _, filepath in pairs(files) do
			local contents = love.filesystem.read(filepath)

			if contents ~= nil then
				local classpath = filepath:sub(#path + 1):gsub("%.lua", ""):gsub("/", ".")
				local pkgs, classname = deconstruct(classpath)

				--validate class classpath
				for _, pkg_name in pairs(pkgs) do
					if pkg_name == "" or not match(pkg_name, "^[a-zA-Z]+[0-9]*$") then
						error(filepath .. ": class must be a valid class path", 2)
					end
				end

				if classname == "" or not match(classname, "^[a-zA-Z]+[0-9]*$") then
					error(filepath .. ": class must be a valid class path", 2)
				end

				local env = { class = {}, [classname] = {} }

				local basename, imports = nil, {}
				function env.base(classpath)
					basename = classpath
				end

				function env.import(classpath)
					insert(imports, classpath)
				end

				setmetatable(env, { __index = _G, __newindex = _G })
				local ok, err = loadstring_env(contents, env)
				if not ok then
					error(filepath .. err, 2)
				end
				setmetatable(env, nil)

				--validate base classpath
				if type(basename) ~= "nil" then
					if type(basename) == "string" then
						local pkgs, pkg_name = deconstruct(basename)

						for _, pkg_name in pairs(pkgs) do
							if pkg_name == "" or not match(pkg_name, "^[a-zA-Z]+[0-9]*$") then
								error(filepath .. ": base class must be a valid class path", 2)
							end
						end

						if pkg_name == "" or not match(pkg_name, "^[a-zA-Z]+[0-9]*$") then
							error(filepath .. ": base class must be a valid class path", 2)
						end
					else
						error(filepath .. ": base class must be string", 2)
					end
				end

				--validate class constructor
				local constructor = rawget(env[classname], classname)

				if type(constructor) ~= "nil" then
					if type(constructor) ~= "function" then
						error(filepath .. ": constructor must be a function")
					end
				end

				packages[classpath] = {
					filepath = filepath,
					compiled = false, 
					base = nil,
					basename = basename, 
					classpath = classpath, 
					classname = classname,
					class = env[classname],
					env = env,
					imports = imports, 
					types = { classpath }
				}
			end
		end
	end

	for _, pkg in pairs(packages) do
		local ok, err = compile(packages, pkg)
		if not ok then
			error(err, 2)
		end
	end

	for _, pkg in pairs(packages) do
		if type(pkg.env.class.loaded) == "function" then
			pkg.env.class.loaded(pkg.env.class, packages)
		end
	end

	return packages
end

return { load = load }