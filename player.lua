local Player = {}

local Vector = require("lib/hump.vector")
  
function Player:load(x, y)
  self.sprite = love.graphics.newImage("assets/sprites/player.png") -- player's sprite
  
  self.pos = Vector(x, y) -- player position
  self.size = {width = self.sprite:getWidth(), height = self.sprite:getHeight()} -- player sprite size
  self.vel = Vector(0, 0) -- how fast the player is moving on the x and y axis
  self.max_speed = 180 -- the maximum speed the player can move
  self.gravity = 400 -- how fast player starts the fall
  self.max_fall_speed = 400 -- the max speed player can fall
  self.jump_strength = 260 -- how high player jumps
  self.accel = 2000 -- how fast player reaches max speed
  self.decel = 1500 -- how fast player speed reaches 0 from their speed
  
  self.grounded = false
  self.jumps = {max = 2, current = 0}
  
  self.physics = {}
  self.physics.body = love.physics.newBody(World, self.pos.x, self.pos.y, "dynamic")
  self.physics.body:setFixedRotation(true)
  self.physics.shape = love.physics.newRectangleShape(self.size.width-8, self.size.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
end

function Player:update(dt)
  self:syncPhysics()
  self:move(dt)
  self:applyGravity(dt)
  print(self.vel)
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
    self:applyDecel(dt)
  end
end 

function Player:applyDecel(dt)
  if self.vel.x > 0 then
    if self.vel.x - self.decel * dt > 0 then
      self.vel.x = self.vel.x - self.decel * dt
    else
      self.vel.x = 0
    end
  elseif self.vel.x < 0 then
    if self.vel.x + self.decel * dt < 0 then
      self.vel.x = self.vel.x + self.decel * dt
    else
      self.vel.x = 0
    end
  end
end

-- makes player's yVel increase by gravity speed until it reaches max_fall_speed
function Player:applyGravity(dt)
  if not self.grounded then
    self.vel.y = math.min(self.vel.y + self.gravity * dt, self.max_fall_speed)
  end
end

function Player:jump()
  self.vel.y = -self.jump_strength
  self.grounded = false
  self.jumps.current = self.jumps.current - 1
end

function Player:draw()
  love.graphics.draw(self.sprite, self.pos.x - self.size.width / 2, self.pos.y - self.size.height / 2)
end

function Player:keypressed(key)
  if key == "z" and self.jumps.current > 0 then
    Player:jump()
  end
end

function Player:beginContact(a, b, collision)
  if self.grounded then return end
  local nx, ny = collision:getNormal()
  if a == self.physics.fixture then
    if ny > 0 then
      self:land(collision)
    end
  elseif b == self.physics.fixture then
    if ny < 0 then
      self:land(collision)
    end
  end
end

function Player:land(collision)
  self.currentGroundCollision = collision
  self.vel.y = 0
  self.grounded = true
  self.jumps.current = self.jumps.max
end

function Player:endContact(a, b, collision)
  if a == self.physics.fixture or b == self.physics.fixture then
    if self.currentGroundCollision == collision then
      self.grounded = false
      self.jumps.current = self.jumps.current - 1
    end
  end
end

return Player