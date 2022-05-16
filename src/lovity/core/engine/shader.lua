local gmatch = string.gmatch
local insert = table.insert

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
	local uniforms, declarations = {}, {}

	--get uniforms
	for declaration in gmatch(code, "uniform%s+([A-Za-z0-9_%[%] ]+)%s*;") do
		insert(declarations, declaration)
	end

	--get externs
	for declaration in gmatch(code, "extern%s+([A-Za-z0-9_%[%] ]+)%s*;") do
		insert(declarations, declaration)
	end

	for _, declaration in pairs(declarations) do
		local type, name = declaration:match("([A-Za-z0-9]+)%s+([A-Za-z0-9_]+)")

		uniforms[name] = type
	end

	return uniforms
end

function shader:shader(code)
	local status, source = pcall(love.graphics.newShader, code)
	
	if status then
		self.source = source
		self.code = code
		self.properties = uniforms(self.code)
	else
		print("shader error:")
		print(source)

		self.code = [[
			#ifdef VERTEX
				vec4 position(mat4 _, vec4 __) {
					return ProjectionMatrix * TransformMatrix * VertexPosition;
				}
			#endif

			#ifdef PIXEL
				vec4 effect(vec4 COLOUR, Image TEXTURE, vec2 UV, vec2 SCREEN) {
					return Texel(TEXTURE, UV) * COLOUR;
				}
			#endif
		]]

		self.source = love.graphics.newShader(self.code)
		self.properties = {}
	end

	return self
end

function shader:send(name, ...)
	local status, err = pcall(self.source.send, self.source, name, ...)
	if not status then
		--print(err)
	end
end

function shader:sendColour(name, ...)
	local property = self.properties[name]
	
	if property then
		if property == "vec3" or property == "vec4" then
			pcall(self.source.sendColor, self.source, name, ...)
		end
	end
end

function shader:hasUniform(name)
	return self.properties[name] ~= nil
end

function shader:getUniformType(name)
	return self.properties[name]
end

function shader:getUniforms()
	return self.properties
end

function shader:use()
	love.graphics.setShader(self.source)
end