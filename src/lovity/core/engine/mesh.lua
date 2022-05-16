local insert = table.insert

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

function mesh:mesh(path)
	self.meshes = {}
	
	for k, object in pairs(obj.load(path)) do
		for i, group in pairs(object.groups) do
			if #group.vertices > 0 then
				insert(self.meshes, love.graphics.newMesh(format, group.vertices, "triangles", "static"))
			end
		end
	end

	return self
end