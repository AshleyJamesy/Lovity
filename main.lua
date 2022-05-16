print("mounting started")
--mounts addons
for _, folder in pairs(love.filesystem.getDirectoryItems("packages")) do
	print("mounting package: " .. folder)
	love.filesystem.mount("packages/" .. folder .. "/src", "src")
end

local packages = class.load("src")

local env = _G
for _, pkg in pairs(packages) do
	local pkgs = {}

	for word in (pkg.classpath .. "."):gmatch("(.-)" .. "%.") do 
		table.insert(pkgs, word)
	end

	local classname = table.remove(pkgs)

	local env = _G
	for _, pkg_name in pairs(pkgs) do
		if env[pkg_name] == nil then
			env[pkg_name] = {}
		end

		env = env[pkg_name]
	end

	env[classname] = pkg.class
end

local shaders = {
		unlit = lovity.core.engine.shader([[
			#ifdef VERTEX
				uniform mat4 uProjection;
				uniform mat4 uView;
				uniform mat4 uModel;

				vec4 position(mat4 _, vec4 __) {
					return uProjection * uView * uModel * VertexPosition;
				}
			#endif

			#ifdef PIXEL
				vec4 effect(vec4 COLOUR, Image TEXTURE, vec2 UV, vec2 SCREEN) {
					return vec4(1.0, 1.0, 1.0, 1.0);
				}
			#endif
		]])
	}

local materials = {
	unlit = lovity.core.engine.material(shaders.unlit)
}

function love.load()
	local scene = lovity.core.engine.sceneManagement.sceneManager:getActiveScene()

	local go = lovity.core.engine.gameObject()
	go:addComponent(lovity.core.engine.camera)
	go:addComponent(mypackage.movement)
end

local j = 0

local cylinder = lovity.core.engine.mesh("assets/models/primitives/cylinder.obj")

function love.update(dt)
	lovity.core.engine.input:update()

	local scene = lovity.core.engine.sceneManagement.sceneManager:getActiveScene()
	scene:update(dt)

	lovity.core.engine.input:lateupdate()

	if j < 20000 then
		for i = 1, 100 do
			local go = lovity.core.engine.gameObject()
			go.static = true
			local mr = go:addComponent(lovity.core.engine.meshRenderer)
			mr.mesh = cylinder
			mr:addMaterial(materials.unlit)
			mr.transform.position:set(math.random() * 1000 - 500, math.random() * 1000 - 500, math.random() * 1000 - 500)

			j = j + 1

			if j < 20000 then
			else
				break
			end
		end
	end
end

function love.draw()
	local scene = lovity.core.engine.sceneManagement.sceneManager:getActiveScene()
	scene:draw()

	if lovity.core.engine.camera.main ~= nil then
		love.graphics.draw(lovity.core.engine.camera.main.buffers[1], 0, love.graphics.getHeight(), 0, 1, -1)
	end

	love.graphics.print("Memory:\nVRAM:\nFPS:\nObjects:\nRendering:", 25, 25)
	love.graphics.print(
		string.format("%.2f Mb", collectgarbage("count") / (1024)) .. "\n" .. 
		string.format("%.2f Mb", love.graphics.getStats().texturememory / (1024 ^ 2)) .. "\n" .. 
		love.timer.getFPS() .. "\n" ..
		(scene.objects["lovity.core.engine.meshRenderer"] ~= nil and #scene.objects["lovity.core.engine.meshRenderer"] or 0) .. "\n" ..
		(lovity.core.engine.camera.main.stats.rendering .. " / " .. (scene.objects["lovity.core.engine.meshRenderer"] ~= nil and #scene.objects["lovity.core.engine.meshRenderer"] or 0)), 100, 25)
end