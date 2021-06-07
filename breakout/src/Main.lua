local Object = require 'src/Object'

local HighScoreRepo = require 'src/repositories/HighScore'
local FPSView = require 'src/views/FPS'
local BackgroundView = require 'src/views/Background'

local Main = Object()

function Main:initialize()
    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())

    -- set the application title bar
    love.window.setTitle('Breakout')

    -- load up the graphics we'll be using throughout our states
    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/breakout.png'),
        ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png')
    }

    -- Quads we will generate for all of our textures; Quads allow us
    -- to show only part of a texture and not the entire thing
    gFrames = {
        ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24),
        ['paddles'] = GenerateQuadsPaddles(gTextures['main']),
        ['balls'] = GenerateQuadsBalls(gTextures['main']),
        ['bricks'] = GenerateQuadsBricks(gTextures['main']),
        ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9)
    }

    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- set up our sound effects; later, we can just index this table and
    -- call each entry's `play` method
    gSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'stream'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'stream'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'stream'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'stream'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'stream'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'stream'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'stream'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'stream'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'stream'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'stream'),
        ['recover'] = love.audio.newSource('sounds/recover.wav', 'stream'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'stream'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'stream'),

        ['music'] = love.audio.newSource('sounds/music.wav', 'stream')
    }

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
    gStateMachine = Scenes {
        ['start'] = function() return Start() end,
        ['play'] = function() return Play() end,
        ['serve'] = function() return Serve() end,
        ['game-over'] = function() return GameOver() end,
        ['victory'] = function() return Victory() end,
        ['high-scores'] = function() return HighScore() end,
        ['enter-high-score'] = function() return EnterHighScore() end,
        ['paddle-select'] = function() return PaddleSelect() end
    }
    gStateMachine:change('start', {
        highScores = HighScoreRepo():load()
    })

    -- Views
    self.views = {BackgroundView(), gStateMachine, FPSView()}

    -- play our music outside of all states and set it to looping
    --gSounds['music']:play()
    --gSounds['music']:setLooping(true)
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