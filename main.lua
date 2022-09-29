local Gamestate = require("lib/hump.gamestate") -- boilerplate generator

local Player = require "player"
local Stage1 = require "stage1"

function love.load()
  love.graphics.setDefaultFilter("nearest")
  
  World = love.physics.newWorld()
  
  Gamestate.registerEvents()
  Gamestate.switch(Stage1)
end

function love.keypressed(key)
  Player:keypressed(key)
end