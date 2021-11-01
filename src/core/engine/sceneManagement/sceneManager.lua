class.name = "engine.sceneManagement.sceneManager"

local scene

function script:onLoad(env)
	scene = engine.sceneManagement.scene
end

class.scenes 		= {}
class.sceneCount 	= 0
class.activeScene 	= nil

function class:sceneManager()
	return class
end

function class:getActiveScene()
	if class.activeScene == nil then
		class.activeScene = scene("scene")
	end

	return class.activeScene
end