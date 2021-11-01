class.compile("src/core/", _G) --compiles classes to _G

love.mouse.setRelativeMode(true)

local sceneManager = engine.sceneManagement.sceneManager

function love.load()
	local shaders = {}
	table.insert(shaders, engine.shader("assets/shaders/debug.glsl"))
	table.insert(shaders, engine.shader("assets/shaders/debug_lit.glsl"))
	table.insert(shaders, engine.shader("assets/shaders/textured.glsl"))
	table.insert(shaders, engine.shader("assets/shaders/textured_lit.glsl"))
	table.insert(shaders, engine.shader("assets/shaders/geometry.glsl"))

	--TODO: json config
	local materials = {}
	table.insert(materials, engine.material(shaders[1])) --debug
	table.insert(materials, engine.material(shaders[1])) --debug
	table.insert(materials, engine.material(shaders[3])) --texture
	table.insert(materials, engine.material(shaders[2])) --debug lit
	table.insert(materials, engine.material(shaders[4])) --texture lit
	table.insert(materials, engine.material(shaders[5])) --deffered geometry

	materials[1].wireframe = true
	materials[3]:setProperty("iAlbedo", love.graphics.newImage("assets/images/uv_grid.png"))
	materials[5]:setProperty("iAlbedo", love.graphics.newImage("assets/images/uv_grid.png"))

	materials[6]:setProperty("iAlbedo", love.graphics.newImage("assets/images/rusted_iron/rustediron2_basecolor.png"))
	materials[6]:setProperty("iMettalic", love.graphics.newImage("assets/images/rusted_iron/rustediron2_metallic.png"))
	materials[6]:setProperty("iRoughness", love.graphics.newImage("assets/images/rusted_iron/rustediron2_normal.png"))
	materials[6]:setProperty("iNormal", love.graphics.newImage("assets/images/rusted_iron/rustediron2_roughness.png"))

	local meshes = {
		engine.mesh("assets/meshes/torus.obj"),
		engine.mesh("assets/meshes/cylinder.obj"),
		engine.mesh("assets/meshes/sphere.obj"),
		engine.mesh("assets/meshes/cube.obj"),
		engine.mesh("assets/meshes/plane.obj"),
	}

	local scene = sceneManager:getActiveScene()

	--CAMERA
	local goCamera = engine.gameObject()
	goCamera:addComponent(movement)
	goCamera:addComponent(engine.camera)

	--CAMERA LIGHT
	local gameObject = engine.gameObject()
	gameObject.transform.position:set(0, 0, -5)
	gameObject.transform.scale:set(0.1, 0.1, 0.1)
	local mr = gameObject:addComponent(engine.meshRenderer, meshes[3])
	mr:addMaterial(materials[2])
	local light = gameObject:addComponent(engine.light)
	light.colour:set(0.0, 1.0, 1.0, 1.0)
	goCamera.transform:addChild(gameObject.transform)

	--LIGHTS[1]
	local goLight = engine.gameObject()
	local r = goLight:addComponent(rotate)
	r.elapsed = 0
	goLight.transform.scale:set(0.1, 0.1, 0.1)
	goLight.transform.position:set(2, 2, -2)
	local light = goLight:addComponent(engine.light)
	light.colour:set(1.0, 0.0, 0.0, 1.0)
	local mr = goLight:addComponent(engine.meshRenderer, meshes[3])
	mr:addMaterial(materials[2])

	--LIGHTS[2]
	local goLight = engine.gameObject()
	local r = goLight:addComponent(rotate)
	r.elapsed = math.pi * 10
	goLight.transform.scale:set(0.1, 0.1, 0.1)
	goLight.transform.position:set(2, 2, 2)
	local light = goLight:addComponent(engine.light)
	light.colour:set(0.0, 1.0, 0.0, 1.0)
	local mr = goLight:addComponent(engine.meshRenderer, meshes[3])
	mr:addMaterial(materials[2])

	--LIGHTS[3]
	local goLight = engine.gameObject()
	goLight.transform.scale:set(0.1, 0.1, 0.1)
	goLight.transform.position:set(0, 2, 0)
	local light = goLight:addComponent(engine.light)
	light.colour:set(0.0, 0.0, 1.0, 1.0)
	local mr = goLight:addComponent(engine.meshRenderer, meshes[3])
	mr:addMaterial(materials[2])

	--MESHES AND MATERIALS
	for j, mesh in pairs(meshes) do
		for i, material in pairs(materials) do
			local x, y = (i - 1) * 2, (j - 1) * 2

			local gameObject = engine.gameObject()
			gameObject.transform.scale:set(1, 1, 1)

			gameObject.transform.position:set(x - ((#materials - 1) * 2) * 0.5, 0, y - ((#meshes - 1) * 2) * 0.5)
			local mr = gameObject:addComponent(engine.meshRenderer, mesh)
			mr:addMaterial(material)
		end
	end

	--TRANSFORM X,Y,Z TESTING
	local gameObjectParent = engine.gameObject()
	gameObjectParent.transform.scale:set(0.5, 0.5, 0.5)
	gameObjectParent.transform.position:set(7, 0, 0)
	gameObjectParent:addComponent(spin)
	local mr = gameObjectParent:addComponent(engine.meshRenderer, meshes[4])
	mr:addMaterial(materials[2])

	local gameObjectChild1 = engine.gameObject()
	gameObjectChild1.transform.scale:set(1, 1, 1)
	gameObjectChild1.transform.position:set(1.5, 0, 0)
	local mr = gameObjectChild1:addComponent(engine.meshRenderer, meshes[4])
	mr.colour:set(1.0, 0.0, 0.0, 1.0)
	mr:addMaterial(materials[2])

	local gameObjectChild2 = engine.gameObject()
	gameObjectChild2.transform.scale:set(1, 1, 1)
	gameObjectChild2.transform.position:set(0, 1.5, 0)
	local mr = gameObjectChild2:addComponent(engine.meshRenderer, meshes[4])
	mr.colour:set(0.0, 1.0, 0.0, 1.0)
	mr:addMaterial(materials[2])

	local gameObjectChild3 = engine.gameObject()
	gameObjectChild3.transform.scale:set(1, 1, 1)
	gameObjectChild3.transform.position:set(0, 0, 1.5)
	local mr = gameObjectChild3:addComponent(engine.meshRenderer, meshes[4])
	mr.colour:set(0.0, 0.0, 1.0, 1.0)
	mr:addMaterial(materials[2])

	gameObjectParent.transform:addChild(gameObjectChild1.transform)
	gameObjectParent.transform:addChild(gameObjectChild2.transform)
	gameObjectParent.transform:addChild(gameObjectChild3.transform)

	--WORLD POSITION TESTING
	local axis = {
		moveAlongX,
		moveAlongY,
		moveAlongZ
	}

	--MOVE ALONG EACH AXIS
	for k, v in pairs(axis) do
		local gameObjectParent = engine.gameObject()
		gameObjectParent.transform.scale:set(0.5, 0.5, 0.5)
		gameObjectParent.transform.position:set(0, 5, 0)
		gameObjectParent:addComponent(v)
		local mr = gameObjectParent:addComponent(engine.meshRenderer, meshes[4])
		mr:addMaterial(materials[2])
	end
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end

function love.fixedupdate(dt)
end

function love.update(dt)
	sceneManager:getActiveScene():update(dt)
end

function love.render()
	local scene = sceneManager:getActiveScene()
	scene:render()

	if engine.camera.main then
		local canvas = engine.camera.main.buffers[1]
		local aw, ah = love.graphics.getWidth() / canvas:getWidth(), love.graphics.getHeight() / canvas:getHeight()

		love.graphics.draw(canvas, 0, 0, 0, aw, ah)
	end

	local stats = {
		{
			name = "FPS",
			value = love.timer.getFPS(),
			tabs = 1
		}
	}

	--STATISTICS
	if engine.camera.main then
		if scene.objects["engine.meshRenderer"] then
			table.insert(stats, {
				name = "Objects",
				value = #scene.objects["engine.meshRenderer"],
				tabs = 1,
			})

			table.insert(stats, {
				name = "Rendering",
				value = engine.camera.main.stats.rendering .. " / " .. #scene.objects["engine.meshRenderer"],
				tabs = 1
			})
		end
	end

	local s = ""
	for k, stat in pairs(stats) do
		s = s .. stat.name .. ":" .. string.rep("\t", stat.tabs or 1) .. tostring(stat.value) .. "\n"
	end

	love.graphics.print(s, 25, 25)
end