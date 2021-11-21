io.stdout:setvbuf("no")

DEBUG 		= false
SERVER 		= false
DEDICATED 	= false
CLIENT 		= true
ARGUMENTS 	= {}

argv = {}
for _, v in ipairs(arg) do 
	argv[v] = true
end

if argv["-debug"] then
	DEBUG = true
end

if argv["-server"] then
	SERVER = true
end

if argv["-dedicated"] then
	CLIENT = false
	SERVER = true
	DEDICATED = true
end

function love.conf(t)
	t.title 	= "Engine"
	t.version 	= "11.3"

	t.modules.audio = not DEDICATED
	t.modules.event = true
	t.modules.graphics = not DEDICATED
	t.modules.image = not DEDICATED
	t.modules.joystick = not DEDICATED
	t.modules.keyboard = true
	t.modules.math = true
	t.modules.mouse = true
	t.modules.physics = true
	t.modules.sound = not DEDICATED
	t.modules.system = true
	t.modules.timer = true
	t.modules.touch = not DEDICATED
	t.modules.video = not DEDICATED
	t.modules.window = not DEDICATED
	t.modules.thread = true

	if not DEDICATED then
		--t.window.icon = "?"

		require("love.system")

		if love.system.getOS() == "OS X" then
			--t.window.icon = "?"
		end

		t.audio.mic = false 					-- Request and use microphone capabilities in Android (boolean)
		t.audio.mixwithsystem = true 			-- Keep background music playing when opening LOVE (boolean, iOS and Android only)

		t.window.title = "engine" 				-- The window title (string)
		t.window.icon = nil 					-- Filepath to an image to use as the window's icon (string)
		t.window.width = 800 					-- The window width (number)
		t.window.height = 600 					-- The window height (number)
		t.window.borderless = false 			-- Remove all border visuals from the window (boolean)
		t.window.resizable = false 				-- Let the window be user-resizable (boolean)
		t.window.minwidth = 1 					-- Minimum window width if the window is resizable (number)
		t.window.minheight = 1 					-- Minimum window height if the window is resizable (number)
		t.window.fullscreen = false 			-- Enable fullscreen (boolean)
		t.window.fullscreentype = "desktop" 	-- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)
		t.window.vsync = 0 						-- Vertical sync mode (number)
		t.window.msaa = 8 						-- The number of samples to use with multi-sampled antialiasing (number)
		t.window.depth = nil 					-- The number of bits per sample in the depth buffer
		t.window.stencil = nil 					-- The number of bits per sample in the stencil buffer
		t.window.display = 1 					-- Index of the monitor to show the window in (number)
		t.window.highdpi = true 				-- Enable high-dpi mode for the window on a Retina display (boolean)
		t.window.usedpiscale = true 			-- Enable automatic DPI scaling when highdpi is set to true as well (boolean)
		t.window.x = nil 						-- The x-coordinate of the window's position in the specified display (number)
		t.window.y = nil 						-- The y-coordinate of the window's position in the specified display (number)
	else
		require("love.system")
	end

	require("src.modules.init")
end

love.run = function()
	math.randomseed(os.time())
	
	local t = love.timer
	local g = love.graphics

	if love.load then 
		love.load(love.arg.parseGameArguments(arg), arg)
	end
	
	t.step()
	
	local dt = 0.0
	local acc = 0.0

	return function()
		if love.event then
			love.event.pump()
			for name, a, b, c, d, e, f in love.event.poll() do
				if name == 'quit' then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				
				love.handlers[name](a, b, c, d, e, f)
			end
		end
		
		if love.timer then
			dt = t.step(); acc = math.min(acc + dt, 0.333333)
		end
		
		if love.fixedupdate then
			while acc >= 0.016 do
				love.fixedupdate(0.016)
				acc = acc - 0.016
			end
		end

		if love.update then
			love.update(dt)
		end
		
		if g and g.isActive() then
			g.origin()
			g.clear(g.getBackgroundColor())
			
			if love.render then 
				love.render()
			end
			
			g.present()
		end
		
		t.sleep(0.0)
	end
end