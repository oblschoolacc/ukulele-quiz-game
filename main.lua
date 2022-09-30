local Gamestate = require("lib/hump.gamestate") -- boilerplate generator

local Player = require "player"
local Stage1 = require "stage1"

function love.load()
  love.graphics.setDefaultFilter("nearest")
  
  World = love.physics.newWorld(0, 0)
  World:setCallbacks(beginContact, endContact)
  
  Gamestate.registerEvents()
  Gamestate.switch(Stage1)
end

function love.update(dt)
  World:update(dt)
end

function love.keypressed(key)
  Player:keypressed(key)
end

function beginContact(a, b, collision)
  Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
  Player:endContact(a, b, collision)
end