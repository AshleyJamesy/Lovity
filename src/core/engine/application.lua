class.name = "application"
class.isMobilePlatform = love.system.getOS() == "Android" or love.system.getOS() == "iOS"

function class:application()
	return class
end