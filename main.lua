class.compile("src/core/", _G) --compiles classes to _G

love.mouse.setRelativeMode(true)

local sceneManager = engine.sceneManagement.sceneManager

function love.load()
	myscene:createTestScene()
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

	--STATISTICS
	local stats = {
		{
			name = "FPS",
			value = love.timer.getFPS(),
			tabs = 1
		}
	}

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
		else
			table.insert(stats, {
				name = "Objects",
				value = 0,
				tabs = 1,
			})

			table.insert(stats, {
				name = "Rendering",
				value = "0 / 0",
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