local Object = require 'src/Object'

local HighScoreRepo = require 'src/repositories/HighScore'
local FPSView = require 'src/views/FPS'
local BackgroundView = require 'src/views/Background'
local Constants = require 'src/constants'
local Scenes = require 'src/scenes/Scenes'
local PaddleSelect = require 'src/scenes/PaddleSelect'
local EnterHighScore = require 'src/scenes/EnterHighScore'
local HighScore = require 'src/scenes/HighScore'
local GameOver = require 'src/scenes/GameOver'
local Play = require 'src/scenes/Play'
local Scenes = require 'src/scenes/Scenes'
local Start = require 'src/scenes/Start'
local Victory = require 'src/scenes/Victory'
local Serve = require 'src/scenes/Serve'


local Main = Object()

function Main:initialize()
    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())

    -- set the application title bar
    love.window.setTitle('Breakout')


    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(Constants.VIRTUAL_WIDTH, Constants.VIRTUAL_HEIGHT, Constants.WINDOW_WIDTH, Constants.WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    self:initialize_scenes()
    self.scenes:change('start', {
        highScores = HighScoreRepo():load()
    })

    -- Views
    self.views = {BackgroundView(), self.scenes, FPSView()}

    -- play our music outside of all states and set it to looping
    --Constants.gSounds['music']:play()
    --Constants.gSounds['music']:setLooping(true)
end

function Main:initialize_scenes()
    self.scenes = Scenes({})
    self.scenes:new_scene('start', function() return Start(self.scenes) end)
    self.scenes:new_scene('play', function() return Play(self.scenes) end)
    self.scenes:new_scene('serve', function() return Serve(self.scenes) end)
    self.scenes:new_scene('game-over', function() return GameOver(self.scenes) end)
    self.scenes:new_scene('victory', function() return Victory(self.scenes) end)
    self.scenes:new_scene('high-scores', function() return HighScore(self.scenes) end)
    self.scenes:new_scene('enter-high-score', function() return EnterHighScore(self.scenes) end)
    self.scenes:new_scene('paddle-select', function() return PaddleSelect(self.scenes) end)
end

function Main:resize(...)
    push:resize(...)
end

function Main:update(dt)
    -- this time, we pass in dt to the state object we're currently using
    self.scenes:update(dt)
end

function Main:render()
    -- begin drawing with push, in our virtual resolution
    push:apply('start')

    table.apply(self.views, function(view) view:render() end)

    push:apply('end')
end

return Main