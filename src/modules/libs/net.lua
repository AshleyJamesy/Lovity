local min = math.min
local max = math.max

local data = require("love.data")
local thread = require("love.thread")
local p = data.pack
local u = data.unpack

local mt_stream = {
	bytes = "",
	index = 1,
	__len = function(stream)
		return #stream.bytes
	end,
	writeBool = function(stream, bool)
		stream.bytes = stream.bytes .. p("string", "B", bool and 1 or 0)
	end,
	writeInt = function(stream, int)
		stream.bytes = stream.bytes .. p("string", "i4", int)
	end,
	writeFloat = function(stream, float)
		stream.bytes = stream.bytes .. p("string", "f", float)
	end,
	writeDouble = function(stream, double)
		stream.bytes = stream.stream .. p("string", "d", double)
	end,
	writeString = function(stream, str)
		stream.bytes = stream.bytes .. p("string", "s4", str)
	end,
	readBool = function(stream)
		local n, bytes = u("B", stream.bytes, stream.index)
		stream.index = bytes

		return n == 1, bytes
	end,
	readInt = function(stream)
		local i, bytes = u("i4", stream.bytes, stream.index)
		stream.index = bytes

		return i, bytes
	end,
	readFloat = function(stream)
		local f, bytes = u("f", stream.bytes, stream.index)
		stream.index = bytes

		return f, bytes
	end,
	readDouble = function(stream)
		local double, bytes = u("d", stream.bytes, stream.index)
		stream.index = bytes
		
		return double, bytes
	end,
	readString = function(stream)
		local str, bytes = u("s4", stream.bytes, stream.index)
		stream.index = bytes
		
		return str, bytes
	end,
	pack = function(stream, format, value)
		stream.bytes = stream.bytes .. p("string", format, value)
	end,
	unpack = function(stream, format)
		local n, bytes = u(format, stream.bytes, stream.index)
		stream.index = bytes
		
		return n, bytes
	end,
	setBytes = function(stream, bytes)
		stream.bytes = bytes
	end,
	getBytes = function(stream)
		return stream.bytes
	end,
	seek = function(stream, i)
		stream.index = i
	end
}

local net_thread, ch_send, ch_receive

local states, callbacks, send, read = {}, {}, setmetatable({ bytes = "", index = 1 }, mt_stream), setmetatable({ bytes = "", index = 1 }, mt_stream)

local function init(address, max_connections, max_channels, incoming, outgoing)
	ch_send = thread.newChannel()
	ch_receive = thread.newChannel()

	net_thread = thread.newThread([[
		local config, ch_send, ch_receive = ...

		local event = require("love.event")
		local enet = require("enet")

		host = enet.host_create(config.address, config.max_connections, config.max_channels, config.incoming, config.outgoing)

		local states = {}
		for i = 1, config.max_connections do
			states[i] = {
				id 		= 0,
				index 	= i,
				address = "",
				ip 		= "",
				port 	= "",
				state 	= "disconnected"
			}
		end

		local statesByAddress = {}

		while true do
			if host then
				local status, packet
				status, packet = pcall(host.service, host)

				while packet do
					local state = states[packet.peer:index()]

					if packet.type == "receive" then
						ch_receive:push({ type = "message", address = state.address, data = packet.data })
					end

					status, packet = pcall(host.service, host)
				end

				for index, state in pairs(states) do
					local peer = host:get_peer(index)

					if peer then
						if state.state ~= peer:state() then
							state.id = peer:connect_id()
							state.address = tostring(peer)
							state.ip = tostring(peer):match("(.*):.*")
							state.port = tostring(peer):match(".*:(.*)")
							state.state = peer:state()

							if state.state == "connected" then
								statesByAddress[state.address] = state
							end

							if state.state == "disconnected" then
								statesByAddress[state.address] = nil
							end

							ch_receive:push({ type = "state", address = state.address, state = state.state })
						end
					end
				end

				local outgoing = ch_send:pop()

				while outgoing do
					if outgoing.action == "send" then
						if outgoing.to == nil then
							host:broadcast(outgoing.data, outgoing.channel, (outgoing.flag and "reliable" or "unreliable"))
						else
							local state = statesByAddress[outgoing.to]

							if state then
								local peer = host:get_peer(state.index)
								if peer then
									peer:send(outgoing.data, outgoing.channel, (outgoing.flag and "reliable" or "unreliable"))
								end
							end
						end
					else
						if outgoing.action == "connect" then
							host:connect(outgoing.to)
						end

						if outgoing.action == "disconnect" then
							local state = statesByAddress[outgoing.to]

							if state then
								host:get_peer(state.index):disconnect_later(outgoing.data)
							end
						end
					end

					outgoing = ch_send:pop()
				end
			end
		end
	]])

	local configuration = {
		address = address,
		max_connections = max_connections,
		max_channels = max_channels,
		incoming = incoming,
		outgoing = outgoing
	}

	net_thread:start(configuration, ch_send, ch_receive)
end

--TODO: optimise packet into bytes instead of table
--[[
		ACTION:
			0 = connect
			1 = disconnect
			2 = send

		FLAG:
			0 = reliable
			1 = unsequenced
			2 = unreliable

                 CHAR    BOOLEN    CHAR    CHAR    CHAR    CHAR    INT     DATA
		BYTES: [ACTION][  FLAG  ][ 255  ][ 255  ][ 255  ][ 255  ][ PORT ][ .... ]
		       [ACTION][  FLAG  ][         IP ADDRESS           ][ PORT ][ .... ]


]]
local packet = 
{
	action 	= "",
	flag = "",
	to = nil,
	data = "",
}

local function connect(address, server)
	if net_thread and ch_send then
		packet.action = "connect"
		packet.address = address
		ch_send:push(packet)
	end
end

local function disconnect(address, data)
	if net_thread and ch_send then
		packet.action = "disconnect"
		packet.to = address
		packet.data = data
		ch_send:push(packet)
	end    
end

local function send(address, reliable)
	if net_thread and ch_send then
		packet.action = "send"
		packet.to = address
		packet.data = send:getBytes()
		packet.flag = not reliable
		ch_send:push(packet)
		send:setBytes("")
	 end
end

local function broadcast(reliable)
	if net_thread and ch_send then
		packet.action = "send"
		packet.to = nil
		packet.data = send:getBytes()
		packet.flag = not reliable
		ch_send:push(packet)
		send:setBytes("")
	end
end

local function update()
	while true do
		local receive = ch_receive:pop()

		if receive == nil then
			break
		end

		if receive.type == "message" then
			read:setBytes(receive.data)
			read:seek(1)

			local msg, bytes = read:readString()
 
			if callbacks[msg] ~= nil then
				for _, callback in pairs(callbacks[msg]) do
					read:seek(bytes)
					callback(receive.address)
				end
			end
		elseif receive.type == "state" then
			for _, callback in pairs(states) do
				callback(receive.address, receive.state)
			end
		end
	end
end

local function receive(message, callback)
	if callbacks[message] == nil then
		callbacks[message] = {}
	end

	table.insert(callbacks[message], callback)
end

local function state(callback)
	table.insert(states, callback)
end

local function start(message)
	send:setBytes("")
	send:writeString(message)
end

local function writeBool(bool)
	send:writeBool(bool)
end

local function readBool()
	return read:readBool()
end

local function writeInt(int)
	send:writeInt(int)
end

local function readInt()
	return read:readInt()
end

local function writeFloat(float)
	send:writeFloat(float)
end

local function readFloat()
	return read:readFloat()
end

local function writeDouble(double)
	send:WriteDouble(double)
end

local function readDouble()
	return read:readDouble()
end

local function writeString(message)
	send:writeString(message)
end

local function readString()
	return read:readString()
end

local function writeColour(r, g, b, a)
	send:pack("B", ceil(max(r, 255)))
	send:pack("B", ceil(max(g, 255)))
	send:pack("B", ceil(max(b, 255)))
	send:pack("B", ceil(max(a, 255)))
end

local function readColour()
	local r = read:unpack("B")
	local g = read:unpack("B")
	local b = read:unpack("B")
	local a = read:unpack("B")

	return r / 255, g / 255, b / 255, a / 255
end

return {
	init = init,
	connect = connect,
	disconnect = disconnect,
	start = start,
	broadcast = broadcast,
	send = send,
	update = update,
	receive = receive,
	state = state,
	writeInt = writeInt,
	readInt = readInt,
	writeFloat = writeFloat,
	readFloat = readFloat,
	writeDouble = writeDouble,
	readDouble = readDouble,
	writeString = writeString,
	readString = readString,
	writeColour = writeColour,
	readColour = readColour,
}