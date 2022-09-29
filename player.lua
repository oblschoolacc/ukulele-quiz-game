local Player = {}

local Vector = require("lib/hump.vector")
  
function Player:load(x, y)
  self.pos = Vector(x, y) -- player x and y positions
  self.vel = Vector(0, 0) -- how fast the player is moving on the x and y axis
  self.max_speed = 180 -- the maximum speed the player can move
  self.gravity = 5 -- how fast player starts the fall
  self.max_fall_speed = 400 -- the max speed player can fall
  self.jump_strength = 130 -- how high player jumps
  self.accel = 20 -- how fast player reaches max speed
  self.decel = 20 -- how fast player reaches 0 from their speed
  
  self.physics = {}
  self.physics.body = love.physics.newBody(World, self.pos.x, self.pos.y)
  
  self.sprite = love.graphics.newImage("assets/sprites/player.png") -- player's sprite
end

function Player:update(dt)
  Player:move(dt)
end

function Player:move(dt)
  -- sets player's x velocity to max_speed or -max_speed by accel
  if love.keyboard.isDown("left") then
    self.vel.x = math.max(self.vel.x - self.accel, -self.max_speed)
  elseif love.keyboard.isDown("right") then
    self.vel.x = math.min(self.vel.x + self.accel, self.max_speed)
  else
    if self.vel.x < 0 then
      self.vel.x = self.vel.x + self.decel
    elseif self.vel.x > 0 then
      self.vel.x = self.vel.x - self.decel
    end
  end
  
  -- makes player move left and right by xVel
  self.pos.x = self.pos.x + self.vel.x * dt
  
  -- makes player's yVel increase by gravity speed until it reaches max_fall_speed
  self.vel.y = math.min(self.vel.y + self.gravity, self.max_fall_speed)
  -- makes player move up and down by yVel
  self.pos.y = self.pos.y + self.vel.y * dt
  
end

function Player:jump()
  self.vel.y = -self.jump_strength
end

function Player:draw()
  love.graphics.draw(self.sprite, self.pos.x, self.pos.y)
end

function Player:keypressed(key)
  if key == "z" then
    Player:jump()
  end
end

return Player