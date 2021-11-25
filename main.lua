class.compile("src/core/", _G) --compiles classes to _G

love.mouse.setRelativeMode(true)

local sceneManager = engine.sceneManagement.sceneManager

function love.load()
	scene:createTestScene()
end

function love.fixedupdate(dt)
end

local DELTAS = {}
local POINTS = {}

for i = 1, 100 do
	DELTAS[i] = 0.0
end

function love.fixedupdate(dt)
	local scene = sceneManager:getActiveScene()
	scene:fixedupdate(dt)
end

function love.update(dt)
	local scene = sceneManager:getActiveScene()

	table.remove(DELTAS, 1)
	table.insert(DELTAS, love.timer.getFPS())

	scene:update(dt)
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
		},
		{
			name = "Delta",
			value = DELTAS[#DELTAS],
		},
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

	local aspect = (love.graphics.getWidth() / love.graphics.getHeight()) * 0.75

	love.graphics.push()
	love.graphics.translate(25, 125)

	local points = {}
	for i = 1, 100 do
		local j = ((i - 1) * 2) + 1

		points[j + 0] = (i - 1) * 2.5 * aspect
		points[j + 1] = (1.0 - math.min((DELTAS[i] / 144), 1.0)) * 100 * aspect
	end

	love.graphics.setColor(0.5, 0.5, 0.5, 1.0)
	love.graphics.rectangle("fill", 0, 0, 100 * 2.5 * aspect, 100 * aspect)
	love.graphics.setColor(1.0, 0.0, 0.0, 0.5)
	love.graphics.line(0, 50 * aspect, 100 * 2.5 * aspect, 50 * aspect)
	love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
	love.graphics.line(points)

	love.graphics.pop()

	love.graphics.print(keys, 25, 25)
	love.graphics.print(values, 25, 25)
end