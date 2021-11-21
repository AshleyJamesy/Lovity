class.name = "input"
class.keys = {}
class.mouse = {}
class.touch = {}

local INPUT_STATE = {
	up = 0,
	pressed = 1,
	down = 2,
	released = 3
}

function script:onLoad()
	class.mousePosition = math.vector2(0,0)
	class.mouseDelta = math.vector2(0,0)
	class.mouseWheel = math.vector2(0,0)
end

function class:input()
	return class
end

function class:getKey(key)
	local state = class.keys[key]
	return state ~= nil and (state == INPUT_STATE.pressed or state == INPUT_STATE.down)
end

function class:getKeyDown(key)
	local state = class.keys[key]
	return state ~= nil and state == INPUT_STATE.pressed
end

function class:getKeyUp(key)
	local state = class.keys[key]
	return state == INPUT_STATE.released or state == INPUT_STATE.up
end

function class:getMouseButtonDown(button)
	local state = class.mouse[button]
	return state ~= nil and state == INPUT_STATE.pressed
end

function class:getMouseButton(button)
	local state = class.mouse[button]
	return state ~= nil and (state == INPUT_STATE.pressed or state == INPUT_STATE.down)
end

function class:getMouseButtonUp(button)
	local state = class.mouse[button]
	return state == INPUT_STATE.released or state == INPUT_STATE.up
end

function class:getMousePosition()
	return class.mousePosition.x, class.mousePosition.y
end

function class:getMouseDelta()
	return class.mouseDelta.x, class.mouseDelta.y
end

function class:getMouseWheel()
	return class.mouseWheel.x, class.mouseWheel.y
end

function class:getTouchDown(id)
	local touch = class.touch[id]

	if touch ~= nil then
		return touch.state == INPUT_STATE.pressed
	end

	return false
end

function class:getTouch(id)
	local touch = class.touch[id]

	if touch ~= nil then
		local state = touch.state
		return state == INPUT_STATE.pressed or state == INPUT_STATE.down or state == INPUT_STATE.moved
	end

	return false
end

function class:getTouchUp(id)
	local touch = class.touch[id]

	if touch ~= nil then
		local state = touch.state
		return state == INPUT_STATE.released or state == INPUT_STATE.up
	end

	return true
end

function class:getTouchStatus(id)
	local touch = class.touch[id]

	if touch ~= nil then
		return touch.state
	end

	return INPUT_STATE.up
end

function class:getTouchMoved(id)
	local touch = class.touch[id]

	if touch ~= nil then
		return touch.state == INPUT_STATE.moved
	end

	return INPUT_STATE.up
end

function class:getTouchPosition(id)
	local touch = class.touch[id]

	if touch ~= nil then
		return touch.position.x, touch.position.y
	end

	return nil
end

function class:update()
	local x, y = love.mouse.getPosition()

	if application.isMobilePlatform then
		if class:getTouch(1) then
			class.mousePosition:set(x, y)
		end
	else
		class.mousePosition:set(x, y)
	end
end

function class:lateupdate()
	for key, state in pairs(class.keys) do
		if state == INPUT_STATE.pressed then
			class.keys[key] = INPUT_STATE.down
		elseif state == INPUT_STATE.released then
			class.keys[key] = INPUT_STATE.up
		end
	end

	for button, state in pairs(class.mouse) do
		if state == INPUT_STATE.pressed then
			class.mouse[button] = INPUT_STATE.down
		elseif state == INPUT_STATE.released then
			class.mouse[button] = INPUT_STATE.up
		end
	end

	for _, touch in pairs(class.touch) do
		local state = touch.state

		if state == INPUT_STATE.pressed then
			touch.state = INPUT_STATE.down
		end

		if state == INPUT_STATE.moved then
			touch.state = INPUT_STATE.down
		end

		if state == INPUT_STATE.released then
			touch.state = INPUT_STATE.up
		end
	end

	class.mousePosition:set(0,0)
	class.mouseDelta:set(0,0)
	class.mouseWheel:set(0,0)
end

function love.keypressed(key, scancode, isrepeat)
	class.keys[key] = INPUT_STATE.pressed
end

function love.keyreleased(key, scancode)
	class.keys[key] = INPUT_STATE.released
end

function love.mousepressed(x, y, button, istouch, presses)
	class.mouse[button] = INPUT_STATE.pressed
	class.mousePosition:set(x,y)
end

function love.mousemoved(x, y, dx, dy, istouch)
	class.mousePosition:set(x,y)
	class.mouseDelta:set(dx,dy)
end

function love.mousereleased(x, y, button, istouch, presses)
	class.mouse[button] = INPUT_STATE.released
	class.mousePosition:set(x,y)
end

function love.mousewheelmoved(x, y)
	class.mouseWheel:set(x,y)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	local uid = string.gsub(tostring(id), "userdata: ", "")
	if uid == "NULL" then uid = 1 else uid = tonumber(uid) + 1 end
	
	class.touch[uid] = {
		id = uid,
		state = INPUT_STATE.pressed,
		touch = id,
		position = math.vector2(x,y),
		delta = math.vector2(dx,dy),
		pressure = pressure
	}
end

function love.touchmoved(id, x, y, dx, dy, pressure)
	local uid = string.gsub(tostring(id), "userdata: ", "")
	if uid == "NULL" then uid = 1 else uid = tonumber(uid) + 1 end

	local touch = class.touch[uid]
	if touch then
		touch.state = INPUT_STATE.moved
		touch.id = uid
		touch.touch = id
		touch.position:set(x, y)
		touch.delta:set(dx, dy)
	end
end

function love.touchreleased(id, x, y, dx, dy, pressure)
	local uid = string.gsub(tostring(id), "userdata: ", "")
	if uid == "NULL" then uid = 1 else uid = tonumber(uid) + 1 end

	local touch = class.touch[uid]
	if touch then
		touch.state = INPUT_STATE.released
		touch.id = uid
		touch.touch = id
		touch.position:set(x, y)
		touch.delta:set(dx, dy)
	end
end