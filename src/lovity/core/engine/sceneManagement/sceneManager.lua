import "lovity.core.engine.sceneManagement.scene"

sceneManager.scenes = {}
sceneManager.sceneCount = 0
sceneManager.activeScene = nil

function sceneManager:sceneManager()
	return sceneManager
end

function sceneManager:getActiveScene()
	if sceneManager.activeScene == nil then
		sceneManager.activeScene = scene("scene")
	end

	return sceneManager.activeScene
end