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



    -- Quads we will generate for all of our textures; Quads allow us
    -- to show only part of a texture and not the entire thing
    gFrames = {
        ['arrows'] = GenerateQuads(Constants.gTextures['arrows'], 24, 24),
        ['paddles'] = GenerateQuadsPaddles(Constants.gTextures['main']),
        ['balls'] = GenerateQuadsBalls(Constants.gTextures['main']),
        ['bricks'] = GenerateQuadsBricks(Constants.gTextures['main']),
        ['hearts'] = GenerateQuads(Constants.gTextures['hearts'], 10, 9)
    }

    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(Constants.VIRTUAL_WIDTH, Constants.VIRTUAL_HEIGHT, Constants.WINDOW_WIDTH, Constants.WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
    -- the state machine we'll be using to transition between various states
    -- in our game instead of clumping them together in our update and draw
    -- methods
    --
    -- our current game state can be any of the following:
    -- 1. 'start' (the beginning of the game, where we're told to press Enter)
    -- 2. 'paddle-select' (where we get to choose the color of our paddle)
    -- 3. 'serve' (waiting on a key press to serve the ball)
    -- 4. 'play' (the ball is in play, bouncing between paddles)
    -- 5. 'victory' (the current level is over, with a victory jingle)
    -- 6. 'game-over' (the player has lost; display score and allow restart)

    gStateMachine = Scenes({})
    gStateMachine:new_scene('start', function() return Start(gStateMachine) end)
    gStateMachine:new_scene('play', function() return Play(gStateMachine) end)
    gStateMachine:new_scene('serve', function() return Serve(gStateMachine) end)
    gStateMachine:new_scene('game-over', function() return GameOver(gStateMachine) end)
    gStateMachine:new_scene('victory', function() return Victory(gStateMachine) end)
    gStateMachine:new_scene('high-scores', function() return HighScore(gStateMachine) end)
    gStateMachine:new_scene('enter-high-score', function() return EnterHighScore(gStateMachine) end)
    gStateMachine:new_scene('paddle-select', function() return PaddleSelect(gStateMachine) end)

    gStateMachine:change('start', {
        highScores = HighScoreRepo():load()
    })

    -- Views
    self.views = {BackgroundView(), gStateMachine, FPSView()}

    -- play our music outside of all states and set it to looping
    --Constants.gSounds['music']:play()
    --Constants.gSounds['music']:setLooping(true)
end

function Main:resize(...)
    push:resize(...)
end

function Main:update(dt)
    -- this time, we pass in dt to the state object we're currently using
    gStateMachine:update(dt)
end

function Main:render()
    -- begin drawing with push, in our virtual resolution
    push:apply('start')

    table.apply(self.views, function(view) view:render() end)

    push:apply('end')
end

return Main