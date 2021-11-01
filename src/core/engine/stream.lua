class.name = "engine.stream"

local p = love.data.pack
local u = love.data.unpack

function class:stream(bytes)
	self.index = 1
	self.bytes = bytes or ""
end

function class.__len(self) 
	return #self.bytes 
end

function class.__eq(a, b)
	return a.bytes == b.bytes
end

function class:writeBool(bool)
	self.bytes = self.bytes .. p("string", "B", bool and 1 or 0)
end

function class:writeInt(int)
	self.bytes = self.bytes .. p("string", "i4", int)
end

function class:writeFloat(float)
	self.bytes = self.bytes .. p("string", "f", float)
end

function class:writeDouble(double)
	self.bytes = self.bytes .. p("string", "d", double)
end

function class:writeString(str)
	self.bytes = self.bytes .. p("string", "s4", str)
end

function class:readInt()
	local i, bytes = u("i4", self.bytes, self.index)
	self.index = bytes

	return i, bytes
end

function class:readFloat()
	local f, bytes = u("f", self.bytes, self.index)
	self.index = bytes

	return f, bytes
end

function class:readDouble()
	local double, bytes = u("d", self.bytes, self.index)
	self.index = bytes
	
	return double, bytes
end

function class:readString()
	local str, bytes = u("s4", self.bytes, self.index)
	self.index = bytes
	
	return str, bytes
end

function class:readBool()
	local n, bytes = u("B", self.bytes, self.index)
	self.index = bytes

	return n == 1, bytes
end

function class:pack(format, value)
	self.bytes = self.bytes .. p("string", format, value)
end

function class:unpack(format)
	local n, bytes = u(format, self.bytes, self.index)
	self.index = bytes
	
	return n, bytes
end

function class:setBytes(bytes)
	self.bytes = bytes
end

function class:getBytes()
	return self.bytes
end

function class:seek(i)
	self.index = i
end