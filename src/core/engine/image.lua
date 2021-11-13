class.name = "engine.image"
class.base = "engine.asset"
class.assetType = "image"

function class:loadAsset()
	local status, source = pcall(love.graphics.newImage, self.path)

	if status then
		self.source = source
	else
		print(source)
	end
end