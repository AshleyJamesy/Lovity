local ffi = require("ffi")

local function ANSICodes()
	local function m(n)
		return string.format("\27[%dm", n)
	end

	function warnImpl(tag, text)
		io.stderr:write(m(1), m(33), "W[", tag, "] ", text, m(0), "\n")
	end

	function errorImpl(tag, text)
		io.stderr:write(m(31), "E[", tag, "] ", text, m(0), "\n")
	end

	function debugImpl(tag, text)
		io.stderr:write(m(1), m(37), "D[", tag, "] ", text, m(0), "\n")
	end
end

local OS = love.system.getOS()

if OS == "Windows" then
	local Kernel32 = ffi.C
	
	ffi.cdef [[
		typedef struct logging_Coord {
			int16_t x, y;
		} logging_Coord;

		typedef struct logging_SmallRect {
			int16_t l, t, r, b;
		} logging_SmallRect;

		typedef struct logging_CSBI {
			logging_Coord csbiSize;
			logging_Coord cursorPos;
			int16_t attributes;
			logging_SmallRect windowRect;
			logging_Coord maxWindowSize;
		} logging_CSBI;

		void* __stdcall GetStdHandle(uint32_t );
		int __stdcall SetConsoleMode(void*, uint32_t);
		int __stdcall GetConsoleMode(void*, uint32_t*);
		int __stdcall GetConsoleScreenBufferInfo(void *, logging_CSBI*);
		int __stdcall SetConsoleTextAttribute(void*, int16_t);
	]]

	if ffi.C then
		local stderr = Kernel32.GetStdHandle(-12)
		local cmode = ffi.new("uint32_t[1]")

		Kernel32.GetConsoleMode(stderr, cmode)

		if Kernel32.SetConsoleMode(stderr, bit.bor(cmode[0], 4)) > 0 then
			ANSICodes()
		end
	end
elseif OS == "Linux" then
	ANSICodes()
end

return {
	option = {
		reset 		= "\x1b[0m",
		bright 		= "\x1b[1m",
		dim 		= "\x1b[2m",
		underscore 	= "\x1b[4m",
		blink 		= "\x1b[5m",
		reverse 	= "\x1b[7m",
		hidden 		= "\x1b[8m"
	},
	colour = {
		black 	= "\x1b[30m",
		red 	= "\x1b[31m",
		green 	= "\x1b[32m",
		yellow 	= "\x1b[33m",
		blue 	= "\x1b[34m",
		magenta = "\x1b[35m",
		cyan 	= "\x1b[36m",
		white 	= "\x1b[37m"
	},
	background = {
		black 		= "\x1b[40m",
		red 		= "\x1b[41m",
		green 		= "\x1b[42m",
		yellow 		= "\x1b[43m",
		blue 		= "\x1b[44m",
		magenta 	= "\x1b[45m",
		cyan 		= "\x1b[46m",
		white 		= "\x1b[47m"
	}
}
