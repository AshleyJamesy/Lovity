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

--TODO: multiple faces
local function load(path, format)
	local info = love.filesystem.getInfo(path)

	if info then
		if info.type == "file" then
			local contents = love.filesystem.read(path):gsub('\r\n', '\n')

			local v = {}
			local t = {}
			local n = {}
			local f = {}

			local vertices = {}

			local lines = split(contents, '\n')

			for _, line in pairs(lines) do
				local args = split(line, "%s+")

				if args[1] == "v" then
					table.insert(v, {
						x = tonumber(args[2]),
						y = tonumber(args[3]),
						z = tonumber(args[4])
					})
				elseif args[1] == "vt" then
					table.insert(t, {
						x = tonumber(args[2]),
						y = tonumber(args[3])
					})
				elseif args[1] == "vn" then
					table.insert(n, {
						x = tonumber(args[2]),
						y = tonumber(args[3]),
						z = tonumber(args[4])
					})
				elseif args[1] == "f" then
					local faceA = split(args[2], "/")
					local faceB = split(args[3], "/")
					local faceC = split(args[4], "/")

					table.insert(f, faceA)
					table.insert(f, faceB)
					table.insert(f, faceC)

					if args[5] ~= nil then
						local faceD = split(args[5], "/")

						table.insert(f, faceA)
						table.insert(f, faceC)
						table.insert(f, faceD)
					end
				end
			end

			for _, face in pairs(f) do
				local vertex = {}

				for k, attribute in pairs(format) do
					if attribute[1] == "VertexPosition" then
						table.insert(vertex, v[tonumber(face[1])].x)
						table.insert(vertex, v[tonumber(face[1])].y)
						table.insert(vertex, v[tonumber(face[1])].z)
					elseif attribute[1] == "VertexTexCoord" then
						table.insert(vertex, t[tonumber(face[2])].x)
						table.insert(vertex, t[tonumber(face[2])].y)
					elseif attribute[1] == "VertexNormal" then
						table.insert(vertex, n[tonumber(face[3])].x)
						table.insert(vertex, n[tonumber(face[3])].y)
						table.insert(vertex, n[tonumber(face[3])].z)
					end
				end

				table.insert(vertices, vertex)
			end

			return vertices
		end
	end
end

return {
	load = load
}