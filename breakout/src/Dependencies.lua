-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'lib/push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'

-- a few global constants, centralized
require 'src/constants'

-- the ball that travels around, breaking bricks and triggering lives lost
require 'src/model/Ball'

-- the entities in our game map that give us points when we collide with them
require 'src/model/Brick'

-- a class used to generate our brick layouts (levels)
require 'src/model/LevelMaker'

-- the rectangular entity the player controls, which deflects the ball
require 'src/model/Paddle'

-- a basic StateMachine class which will allow us to transition to and from
-- game states smoothly and avoid monolithic code in one file
require 'src/scenes/Scenes'

-- utility functions, mainly for splitting our sprite sheet into various Quads
-- of differing sizes for paddles, balls, bricks, etc.
require 'src/model/Util'

-- each of the individual states our game can be in at once; each state has
-- its own update and render methods that can be called by our state machine
-- each frame, to avoid bulky code in main.lua
require 'src/scenes/Base'
require 'src/scenes/EnterHighScore'
require 'src/scenes/GameOver'
require 'src/scenes/HighScore'
require 'src/scenes/PaddleSelect'
require 'src/scenes/Play'
require 'src/scenes/Serve'
require 'src/scenes/Start'
require 'src/scenes/Victory'
require 'lib/table'