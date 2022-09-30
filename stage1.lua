local Gamestate = require("lib/hump.gamestate")
local STI = require("lib/sti")
local Camera = require("lib/hump.camera")

local Stage1 = {}

local Player = require "player"

function Stage1:enter()
  Player:load(0, 0)
  
  self.camera = Camera(Player.pos.x, Player.pos.y)
  self.camera:zoom(1.5)
  self.map = STI("assets/map/s1.lua", {"box2d"})
  self.map:box2d_init(World)
  self.map.layers.collision_layer.visible = false
end



function Stage1:update(dt)
  Player:update(dt)
  local dx, dy = Player.pos.x - self.camera.x, Player.pos.y - self.camera.y
  self.camera:move(dx/2, dy/2)
  self.camera.smooth.linear(0.8)
  self.map:update()
end

function Stage1:draw()
  
  
  self.map:draw(-self.camera.x+love.graphics.getWidth() / (self.camera.scale * 2), -self.camera.y+love.graphics.getHeight() / (self.camera.scale * 2), self.camera.scale)
  
  -- anything called before attach or after detach is not scaled
  -- except for map:draw but that one is built different
  self.camera:attach()
  
  Player:draw()
  
  self.camera:detach()
end

return Stage1