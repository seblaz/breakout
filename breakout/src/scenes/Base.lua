--[[
    GD50
    Breakout Remake

    -- BaseState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Used as the base class for all of our states, so we don't have to
    define empty methods in each of them. StateMachine requires each
    State have a set of four "interface" methods that it can reliably call,
    so by inheriting from this base state, our State classes will all have
    at least empty versions of these methods even if we don't define them
    ourselves in the actual classes.
]]

local Object = require 'src/Object'

local Base = Object()

function Base:enter() end
function Base:exit() end
function Base:update() end
function Base:render() end

return Base