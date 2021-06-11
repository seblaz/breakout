--[[
    GD50 2018
    Breakout Remake

    -- constants --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Some global constants for our application.
]]

local Util = require 'src/model/Util'


local Constants = {
    -- size of our actual window
    WINDOW_WIDTH = 1280,
    WINDOW_HEIGHT = 720,

    -- size we're trying to emulate with push
    VIRTUAL_WIDTH = 432,
    VIRTUAL_HEIGHT = 243,

    -- paddle movement speed
    PADDLE_SPEED = 200,

    -- load up the graphics we'll be using throughout our states
    gTextures = {
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['main'] = love.graphics.newImage('graphics/breakout.png'),
    ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['particle'] = love.graphics.newImage('graphics/particle.png')
    },

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
    },


}

return Constants
