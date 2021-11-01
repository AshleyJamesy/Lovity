class.name = "engine.asset"
class.assetType = "assset"

function class:asset(path)
	assert(path ~= nil, "cannot load nil asset")

	self.path 		= path
	self.meta 		= path .. "." .. "meta"
	self.uuid 		= math.uuid()

	local info = love.filesystem.getInfo(self.path)
	if info then
		self.contents = love.filesystem.read(self.path)

		if info.type == "file" then
			info = love.filesystem.getInfo(self.meta)

			if info then
				if info.type == "file" then
					self:load()
					self:save()
				else
					print("attempted to load meta for asset '" .. path .. "' failed")

					return null
				end
			else
				self:loadAsset()
				self:save()
			end

			return self
		else
			print("attempted to load asset '" .. path .. "' failed")
		end
	else
		print("attempted to load asset '" .. path .. "' failed")
	end
end

function class:save()
	local s = engine.stream()
	s:writeString(self.uuid)

	if not self:saveData(s) then
		local dir = string.GetPath(self.meta)

		if love.filesystem.createDirectory(dir) then
			love.filesystem.write(self.meta, s.bytes)
		end
	end
end

function class:load()
	local info = love.filesystem.getInfo(self.meta)
	if info then
		if info.type == "file" then
			local contents = love.filesystem.read(self.meta)
			local s = engine.stream(contents)
			self.uuid = s:readString()

			self:loadAsset()
			self:loadData(s)

			return
		end
	end

	self:loadAsset()
end

--virtual functions:
function class:loadAsset()
end

function class:loadData(stream)
end

function class:saveData(stream)
end