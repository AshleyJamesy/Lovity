class.name = "engine.monoBehaviour"
class.base = "engine.behaviour"

function class:monoBehaviour()
    class.base.behaviour(self)
end

function class:awake()
end

function class:start()
end