class.name = "engine.shader"
class.base = "engine.asset"
class.assetType = "shader"

local glsl_Types = {
	"void",
	"bool",
	"int",
	"float",
	"vec2",
	"vec3",
	"vec4",
	"bvec2",
	"bvec3",
	"bvec4",
	"ivec2",
	"ivec3",
	"ivec4",
	"mat2",
	"mat3",
	"mat4",
	"mat2x2",
	"mat2x3",
	"mat2x4",
	"mat3x2",
	"mat3x3",
	"mat3x4",
	"mat4x2",
	"mat4x3",
	"mat4x4",
	"sampler1D",
	"sampler2D",
	"sampler3D",
	"samplerCube",
	"sampler1DShadow",
	"sampler2DShadow"
}

--TODO: extract structs
local function uniforms(code)
	local uniforms = {}
	local declarations = {}

	--get uniforms
	for declaration in string.gmatch(code, "uniform%s+([A-Za-z0-9_%[%] ]+)%s*;") do
		table.insert(declarations, declaration)
	end

	--get externs
	for declaration in string.gmatch(code, "extern%s+([A-Za-z0-9_%[%] ]+)%s*;") do
		table.insert(declarations, declaration)
	end

	for _, declaration in pairs(declarations) do
		local type, name = declaration:match("([A-Za-z0-9]+)%s+([A-Za-z0-9_]+)")

		uniforms[name] = {
			name = name,
			type = type
		}
	end

	return uniforms
end

--TODO: prepend default shader uniforms
--such as mat4 projection, mat4 view, mat4 model
function class:loadAsset()
	local status, source = pcall(love.graphics.newShader, self.path)
	
	if status then
		self.source 	= source
		self.code 		= love.filesystem.read(self.path)
		self.properties = uniforms(self.code)
	else
		print("shader error: '" .. self.path .. "'")
		print(source)

		self.code = [[
			#ifdef VERTEX
				vec4 position(mat4 t, vec4 v) {
					return ProjectionMatrix * TransformMatrix * VertexPosition;
				}
			#endif

			#ifdef PIXEL
				vec4 effect(vec4 colour, Image texture, vec2 uv, vec2 screen_coords) {
					return Texel(texture, uv) * colour;
				}
			#endif
		]]

		self.source = love.graphics.newShader(self.code)
		self.properties = {}
	end
end

function class:send(name, ...)
	local status, err = pcall(self.source.send, self.source, name, ...)
	if not status then
		--print(self.path)
		--print("", err)
	end
end

function class:sendColour(name, ...)
	local property = self.properties[name]
	
	if property then
		if property == "vec3" or property == "vec4" then
			pcall(self.source.sendColor, self.source, name, ...)
		end
	end
end

function class:hasUniform(name)
	return self.properties[name] ~= nil
end

function class:getUniforms()
	return self.properties
end

function class:use()
	love.graphics.setShader(self.source)
end

function class:reset()
	love.graphics.setShader()
end