local 
	STATE_UP,
	STATE_PRESSED,
	STATE_DOWN,
	STATE_RELEASED = 0, 1, 2, 3

local KEYBOARD_KEYS, MOUSE_BUTTONS, MOUSE_PRESSES = {}, {}, {}

local MOUSE_DELTA_X, MOUSE_DELTA_Y 			= 0, 0
local MOUSE_POSITION_X, MOUSE_POSITION_Y 	= 0, 0
local MOUSE_WHEEL_X, MOUSE_WHEEL_Y 			= 0, 0

function love.keypressed(key, scancode, isrepeat)
	KEYBOARD_KEYS[key] = STATE_PRESSED
end

function love.keyreleased(key, scancode)
	KEYBOARD_KEYS[key] = STATE_RELEASED
end

function love.mousepressed(x, y, button, istouch, presses)
	MOUSE_BUTTONS[button] = STATE_PRESSED
	MOUSE_POSITION_X = x
	MOUSE_POSITION_Y = y

	MOUSE_PRESSES[button] = presses
end

function love.mousemoved(x, y, dx, dy, istouch)
	MOUSE_DELTA_X = dx
	MOUSE_DELTA_Y = dy
	MOUSE_POSITION_X = x
	MOUSE_POSITION_Y = y
end

function love.mousereleased(x, y, button, istouch, presses)
	MOUSE_BUTTONS[button] = STATE_RELEASED
	MOUSE_POSITION_X = x
	MOUSE_POSITION_Y = y

	MOUSE_PRESSES[button] = presses
end

function love.mousewheelmoved(x, y)
	MOUSE_WHEEL_X = x
	MOUSE_WHEEL_Y = y
end

function input:update()
	MOUSE_POSITION_X, MOUSE_POSITION_Y = love.mouse.getPosition()
end

function input:lateupdate()
	for key, state in pairs(KEYBOARD_KEYS) do
		if state == STATE_PRESSED then
			KEYBOARD_KEYS[key] = STATE_DOWN
		elseif state == STATE_RELEASED then
			KEYBOARD_KEYS[key] = STATE_UP
		end
	end

	for button, state in pairs(MOUSE_BUTTONS) do
		if state == STATE_PRESSED then
			MOUSE_BUTTONS[button] = STATE_DOWN
		elseif state == STATE_RELEASED then
			MOUSE_BUTTONS[button] = STATE_UP
		end
	end

	for button, presses in pairs(MOUSE_PRESSES) do
		MOUSE_PRESSES[button] = 0
	end

	MOUSE_DELTA_X = 0
	MOUSE_DELTA_Y = 0

	MOUSE_WHEEL_X = 0
	MOUSE_WHEEL_Y = 0
end

function input:getKey(key)
	local state = KEYBOARD_KEYS[key]; return state ~= nil and (state == STATE_PRESSED or state == STATE_DOWN) or false
end

function input:getKeyDown(key)
	local state = KEYBOARD_KEYS[key]; return state ~= nil and state == STATE_PRESSED
end

function input:getKeyUp(key)
	local state = KEYBOARD_KEYS[key]; return state == STATE_UP or state == STATE_RELEASED
end

function input:getMouseButton(button)
	local state = MOUSE_BUTTONS[button]; return state ~= nil and (state == STATE_PRESSED or state == STATE_DOWN) or false
end

function input:getMouseButtonDown(button)
	local state = MOUSE_BUTTONS[button]; return state ~= nil and state == STATE_PRESSED or false
end

function input:getMouseButtonPresses(button)
	local presses = MOUSE_PRESSES[button]; return presses ~= nil and presses or 0
end

function input:getMouseButtonUp(button)
	local state = MOUSE_BUTTONS[button]; return state == STATE_UP or state == STATE_RELEASED
end

function input:getMouseDelta()
	return MOUSE_DELTA_X, MOUSE_DELTA_Y
end

function input:getMousePosition()
	return MOUSE_POSITION_X, MOUSE_POSITION_Y
end

function input:getMouseWheel()
	return MOUSE_WHEEL_X, MOUSE_WHEEL_Y
end