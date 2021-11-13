local function split(str, delim)
	local t = {}

	local s = 1
	local ea, eb = str:find(delim)

	while ea ~= nil do
		table.insert(t, #t + 1, str:sub(s, ea - 1))

		s = eb + 1
		ea, eb = str:find(delim, s)
	end

	table.insert(t, #t + 1, str:sub(s, #str))

	return t
end

local function getLastElement(objects)
	return objects[#objects]
end

local function group(object, name)
	table.insert(object.groups, { name = name, format = {}, vertices = {}, indices = {}, extent = { 0, 0, 0 } })
end

local function object(objects, name)
	local object = { name = name, groups = {} }

	group(object, "")

	table.insert(objects, object)
end

local function attribute(lineNum, attribute, args)
	local values = {}

	for i = 1, attribute.components do
		local component = args[i + 1]

		if component == nil then
			error("float component #" .. i .. " at line: " .. lineNum .. " is missing")
		else
			if not component:match("^-*[0-9]*%.*[0-9]*$") then
				error("float component #" .. i .. " at line: " .. lineNum .. " is not a valid number")
			else
				table.insert(values, tonumber(component))
			end
		end
	end

	table.insert(attribute.elements, values)
end

local function flatten(lineNum, attributes, group, face)
	local vertex = {}

	for k, index in pairs(split(face, "/")) do
		if index ~= "" then
			local attribute = attributes[k]
			local element = attribute.elements[tonumber(index)]

			if element ~= nil then
				for i = 1, attribute.components do
					table.insert(vertex, element[i])
				end
			else
				error("face '" .. face .. "' at line " .. lineNum .. " tried to index missing attribute " .. attribute.tag .. "[" .. index .. "]", 4)
			end
		end
	end

	table.insert(group.vertices, vertex)
end

local function load(path)
	local info = love.filesystem.getInfo(path)

	if info then
		if info.type == "file" then
			local objects = {}; object(objects, "")

			local attributes = {
				{
					name = "VertexPosition",
					tag = "v",
					datatype = "float",
					components = 3,
					elements = {}
				},
				{
					name = "VertexTexCoord",
					tag = "vt",
					datatype = "float",
					components = 2,
					elements = {}
				},
				{
					name = "VertexNormal",
					tag = "vn",
					datatype = "float",
					components = 3,
					elements = {}
				}
			}

			local lineNum, contents = 1, love.filesystem.read(path)
			for line in (contents .. (contents:sub(-1) ~= "\n" and "\n" or "")):gmatch("(.-)\n") do
				local args = {}
				for arg in line:gmatch("[^%s]+") do
					table.insert(args, arg)
				end

				local keyword = args[1]

				if keyword ~= nil then
					if keyword == "o" then
						local name = args[2] or ""

						if name ~= "" then
							object(objects, name)
						end
					elseif keyword == "g" then
						local o = getLastElement(objects)

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
						local o = getLastElement(objects)
						local g = getLastElement(o.groups)

						for i = 3, #args do
							flatten(lineNum, attributes, g, args[    2])
							flatten(lineNum, attributes, g, args[i - 1])
							flatten(lineNum, attributes, g, args[i - 0])
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