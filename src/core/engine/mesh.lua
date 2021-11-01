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
	local vertices = obj.load(self.path, format)

	self.source = love.graphics.newMesh(format, vertices, "triangles", "static")

	self.extent = math.vector3()

	for k, vertex in pairs(vertices) do
		local position = math.vector3(vertex[1], vertex[2], vertex[3])
		
		if position:magnitude() > self.extent:magnitude() then
			self.extent = position
		end
	end
end