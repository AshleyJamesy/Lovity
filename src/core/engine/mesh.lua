class.name = "engine.mesh"
class.base = "engine.asset"
class.assetType = "mesh"

local format = {
	{
		"VertexPosition",
		"float",
		3
	},
	{
		"VertexTexCoord",
		"float",
		2
	},
	{
		"VertexNormal",
		"float",
		3
	}
}

function class:loadAsset()
	local objects = obj.load(self.path, format)
	local tmp = math.vector3()

	self.extent = math.vector3()

	self.meshes = {}
	for k, object in pairs(objects) do
		for i, group in pairs(object.groups) do
			if #group.vertices > 0 then
				for j, vertex in pairs(group.vertices) do
					tmp:set(vertex[1], vertex[2], vertex[3])

					if tmp:magnitude() > self.extent:magnitude() then
						self.extent:set(tmp.x, tmp.y, tmp.z)
					end
				end

				local mesh = love.graphics.newMesh(format, group.vertices, "triangles", "static")
				mesh:setVertexMap(group.indices)

				table.insert(self.meshes, mesh)
			end
		end
	end
end