local Player = {

  x,
  y,
  radius = 16,
  speed = 200, -- en px/s
  canon,
  cooldown,
  bombCooldown,
  isInvincible,
  invincibilityCooldown,
  score,
  life,

  init = function(self)
    self.life = 3
    self.score = 0
    self.cooldown = 0
    self.bombCooldown = 0
    self.isInvincible = false
    self.invincibilityCooldown = 0
  end,

  new = function(self, x, y)
    self.x = x
    self.y = y

    return self
  end,

  hit = function(self, index)
    print("ouch")
    self.isInvincible = true
    self.invincibilityCooldown = 1.5
    local _cougth = cougth:clone()
    _cougth:play()
    self.life = self.life -1

  end,

  update = function(self, dt)

    -- GESTION DU COOLDOWN DE L'INVINCIBILITE
    if self.invincibilityCooldown > 0 then
      self.invincibilityCooldown = self.invincibilityCooldown - dt
    end

    if self.invincibilityCooldown <= 0 then
      self.isInvincible = false
    end

    -- GESTION DU COOLDOWN DE L'ARME
    self.cooldown = self.cooldown - dt
    if self.cooldown <= 0 then
      self.cooldown = 0
    end

    -- GESTION DU COOLDOWN DES BOMBES
    self.bombCooldown = self.bombCooldown - dt
    if self.bombCooldown <= 0 then
      self.bombCooldown = 0
    end

    -- GESTION DU DEPLACEMENT

    local vectorDeplacement = Vector:new(0,0)

    if love.keyboard.isDown("z") then
      local vectorUp = Vector:new(self.speed, 90)
      vectorDeplacement = vectorDeplacement:add(vectorUp)
    end

    if love.keyboard.isDown("s") then
      local vectorDown = Vector:new(self.speed, 270)
      vectorDeplacement = vectorDeplacement:add(vectorDown)
    end

    if love.keyboard.isDown("q") then
      local vectorLeft = Vector:new(self.speed, 180)
      vectorDeplacement = vectorDeplacement:add(vectorLeft)
    end

    if love.keyboard.isDown("d") then
      local vectorRight = Vector:new(self.speed, 0)
      vectorDeplacement = vectorDeplacement:add(vectorRight)
    end

    local newX = self.x + vectorDeplacement.x * dt
    local newY = self.y + vectorDeplacement.y * dt

    if MathUtils.getDistance(center.x, center.y, newX, self.y) < gameZoneRadius - self.radius then
      self.x = newX
    end

    if MathUtils.getDistance(center.x, center.y, self.x, newY) < gameZoneRadius - self.radius then -- Si le joueur est à la limite de la zone de jeu
      self.y = newY
    end

    -- GESTION DU CANON
    local _relativeX = love.mouse.getX() - player.x
    local _relativeY = player.y - love.mouse.getY()
    local _canonAngle = math.atan2(_relativeY, _relativeX)

    canon = Vector:new(50, MathUtils.radsTodegrees(_canonAngle))

    -- GESTION DU TIR
    if love.mouse.isDown(1) and self.cooldown == 0 then
      local _projectile = Projectile:new(self.x + canon.x, self.y + canon.y, Vector:new(500, canon.angle)) -- La vitesse du projectile est ici réglée à 500px/s
      table.insert(projectiles, _projectile)
      local _piou = piou:clone()
      _piou:play()
      self.cooldown = 0.1
    end

    if love.keyboard.isDown("space") and Player.bombCooldown == 0 then
      Projectile:newBomb(self.x, self.y)
      self.bombCooldown = 1
    end

  end,

  draw = function(self)

    love.graphics.push()

    if self.isInvincible then
      love.graphics.setColor(1, 1, 1, 0.5)
    else
      love.graphics.setColor(1, 1, 1, 1)
    end

    love.graphics.setLineWidth(1)

    -- Le joueur
    love.graphics.circle('fill', self.x, self.y, self.radius, 32)

    -- Le curseur de visée
    love.graphics.circle('line', love.mouse.getX(), love.mouse.getY(), 16, 32)
    love.graphics.line(love.mouse.getX()-16-5, love.mouse.getY(), love.mouse.getX()-16+5, love.mouse.getY())
    love.graphics.line(love.mouse.getX()+16-5, love.mouse.getY(), love.mouse.getX()+16+5, love.mouse.getY())
    love.graphics.line(love.mouse.getX(), love.mouse.getY()-16-5, love.mouse.getX(), love.mouse.getY()-16+5)
    love.graphics.line(love.mouse.getX(), love.mouse.getY()+16-5, love.mouse.getX(), love.mouse.getY()+16+5)

    -- Le canon
    love.graphics.line(self.x, self.y, self.x + canon.x, self.y + canon.y)

    love.graphics.pop()

  end

}


return Player
