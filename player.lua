local Player = {}

local Vector = require("lib/hump.vector")
  
function Player:load(x, y)
  self.sprite = love.graphics.newImage("assets/sprites/player.png") -- player's sprite
  
  self.pos = Vector(x, y) -- player x and y positions
  self.width = self.sprite:getWidth()
  self.height = self.sprite:getHeight()
  self.vel = Vector(0, 0) -- how fast the player is moving on the x and y axis
  self.max_speed = 180 -- the maximum speed the player can move
  self.gravity = 200 -- how fast player starts the fall
  self.max_fall_speed = 400 -- the max speed player can fall
  self.jump_strength = 200 -- how high player jumps
  self.accel = 2000 -- how fast player reaches max speed
  self.decel = 2000 -- how fast player speed reaches 0 from their speed
  
  self.physics = {}
  self.physics.body = love.physics.newBody(World, self.pos.x, self.pos.y, "dynamic")
  self.physics.body:setFixedRotation(true)
  self.physics.shape = love.physics.newRectangleShape(self.width-8, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
end

function Player:update(dt)
  self:move(dt)
  self:syncPhysics()
end

-- synchronizes the sprite position with the physics body
function Player:syncPhysics()
  self.pos.x, self.pos.y = self.physics.body:getPosition()
  self.physics.body:setLinearVelocity(self.vel.x, self.vel.y)
end

function Player:move(dt)
  -- sets player's x velocity to max_speed or -max_speed by accel
  if love.keyboard.isDown("left") then
    self.vel.x = math.max(self.vel.x - self.accel * dt, -self.max_speed)
  elseif love.keyboard.isDown("right") then
    self.vel.x = math.min(self.vel.x + self.accel * dt, self.max_speed)
  else
    self:applyFriction(dt)
  end

  -- makes player's yVel increase by gravity speed until it reaches max_fall_speed
  self.vel.y = math.min(self.vel.y + self.gravity * dt, self.max_fall_speed)
end

function Player:applyFriction(dt)
  if self.vel.x < 0 then
    self.vel.x = self.vel.x + self.decel * dt
  elseif self.vel.x > 0 then
    self.vel.x = self.vel.x - self.decel * dt
  end
end

function Player:jump()
  self.vel.y = -self.jump_strength
end

function Player:draw()
  love.graphics.draw(self.sprite, self.pos.x - self.width / 2, self.pos.y - self.height / 2)
end

function Player:keypressed(key)
  if key == "z" then
    Player:jump()
  end
end

function Player:beginContact(a, b, collision)
  
end

function Player:endContact(a, b, collision)
  
end

return Player