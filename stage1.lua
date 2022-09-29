local Gamestate = require("lib/hump.gamestate")
local STI = require("lib/sti")
local Camera = require("lib/hump.camera")

local Stage1 = {}

local Player = require "player"

function Stage1:enter()
  Player:load(0, 0)
  
  self.camera = Camera(Player.pos.x, Player.pos.y)
  self.camera:zoom(2)
  self.map = STI:load("assets/map/s1.lua", {"box2d"})
end

function Stage1:update(dt)
  Player:update(dt)
  self.camera:lookAt(Player.pos.x, Player.pos.y)
end

function Stage1:draw()
  
  -- anything called before attach or after detach is not scaled
  
  self.camera:attach()
  
  self.map:draw(0, 0)
  Player:draw()
  self.camera:detach()
end

return Stage1