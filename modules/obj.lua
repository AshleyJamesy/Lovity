local insert = table.insert

local function split(str, delim)
	local t = {}

	local s = 1
	local ea, eb = str:find(delim)

	while ea ~= nil do
		insert(t, #t + 1, str:sub(s, ea - 1))

		s = eb + 1
		ea, eb = str:find(delim, s)
	end

	insert(t, #t + 1, str:sub(s, #str))

	return t
end

local function group(object, name)
	insert(object.groups, { name = name, format = {}, vertices = {}, indices = {} })
end

local function object(objects, name)
	local object = { name = name, groups = {} }

	group(object, "")

	insert(objects, object)
end

local function attribute(lineNum, attribute, args)
	local values = {}

	for i = 1, attribute.components do
		local component = args[i + 1]

		if component == nil then
			error("float component #" .. i .. " at line: " .. lineNum .. " is missing")
		else
			if not component:match("^-*[0-9]*%.*[0-9]*$") and not component:match("^-*[0-9]*%.*[0-9]*e%-[0-9]+$") then
				error("float component #" .. i .. " at line: " .. lineNum .. " is not a valid number")
			else
				insert(values, tonumber(component))
			end
		end
	end

	insert(attribute.elements, values)
end

local function flatten(lineNum, attributes, group, face)
	local vertex = {}

	for k, index in pairs(split(face, "/")) do
		if index ~= "" then
			local attribute = attributes[k]
			local element = attribute.elements[tonumber(index)]

			if element ~= nil then
				for i = 1, attribute.components do
					insert(vertex, element[i])
				end
			else
				error("face '" .. face .. "' at line " .. lineNum .. " tried to index missing attribute " .. attribute.tag .. "[" .. index .. "]", 4)
			end
		end
	end

	insert(group.vertices, vertex)
end

local function load(path)
	local info = love.filesystem.getInfo(path)

	if info then
		if info.type == "file" then
			local objects = {}; object(objects, "")

			local attributes = {
				{ name = "VertexPosition", tag = "v", datatype = "float", components = 3, elements = {} },
				{ name = "VertexTexCoord", tag = "vt", datatype = "float", components = 2, elements = {} },
				{ name = "VertexNormal", tag = "vn", datatype = "float", components = 3, elements = {} }
			}

			local lineNum, contents = 1, love.filesystem.read(path)
			for line in (contents .. (contents:sub(-1) ~= "\n" and "\n" or "")):gmatch("(.-)\n") do
				local args = {}
				for arg in line:gmatch("[^%s]+") do
					insert(args, arg)
				end

				local keyword = args[1]

				if keyword ~= nil then
					if keyword == "o" then
						local name = args[2] or ""

						if name ~= "" then
							object(objects, name)
						end
					elseif keyword == "g" then
						local o = objects[#objects]

						local name = args[2] or ""
						if name ~= "" then
							group(o, name)
						end
					elseif keyword == "v" then
						attribute(lineNum, attributes[1], args)
					elseif keyword == "vt" then
						attribute(lineNum, attributes[2], args)
					elseif keyword == "vn" then
						attribute(lineNum, attributes[3], args)
					elseif keyword == "f" then
						local o = objects[#objects]
						local g = o.groups[#o.groups]

						for i = 4, #args do
							flatten(lineNum, attributes, g, args[i - 0])
							flatten(lineNum, attributes, g, args[i - 1])
							flatten(lineNum, attributes, g, args[    2])
						end
					end
				end

				lineNum = lineNum + 1
			end

			return objects
		end
	end
	
end

return {
	load = load
}