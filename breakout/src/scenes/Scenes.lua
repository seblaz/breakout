local Base = require 'src/scenes/Base'
local Object = require 'src/Object'

Scenes = Object()

function Scenes:initialize(scenes)
	self.scenes = scenes or {} -- [name] -> [function that returns states]
	self.current = Base()
end

function Scenes:change(stateName, enterParams)
	assert(self.scenes[stateName]) -- state must exist!
	self.current:exit()
	self.current = self.scenes[stateName]()
	self.current:enter(enterParams)
end

function Scenes:update(dt)
	self.current:update(dt)
end

function Scenes:render()
	self.current:render()
end