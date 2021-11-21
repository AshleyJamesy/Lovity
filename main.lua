class.compile("src/core/", _G) --compiles classes to _G

love.mouse.setRelativeMode(true)

local sceneManager = engine.sceneManagement.sceneManager

function love.load()
	scene:createTestScene()
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
			name = "Memory",
			value = string.format("%.2f Mb", collectgarbage("count") / (1024))
		},
		{
			name = "VRAM",
			value = string.format("%.2f Mb", love.graphics.getStats().texturememory / (1024 ^ 2))
		},
		{
			name = "FPS",
			value = love.timer.getFPS(),
		}
	}

	if engine.camera.main then
		table.insert(stats, {
			name = "Objects",
			value = scene.objects["engine.meshRenderer"] ~= nil and #scene.objects["engine.meshRenderer"] or 0,
		})

		table.insert(stats, {
			name = "Rendering",
			value = engine.camera.main.stats.rendering .. " / " .. (scene.objects["engine.meshRenderer"] ~= nil and #scene.objects["engine.meshRenderer"] or 0),
		})
	end

	local keys, values = "", ""
	for k, stat in pairs(stats) do
		keys = keys .. stat.name .. ":\n"
		values = values .. string.rep("\t", stat.tabs or 5) .. tostring(stat.value) .. "\n"
	end

	love.graphics.print(keys, 25, 25)
	love.graphics.print(values, 25, 25)
end