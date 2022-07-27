local Enemy = {

  x,
  y,
  angle,
  linearSpeed,
  radialSpeed,
  scale,
  texture = love.graphics.newImage("resources/images/covid.png"),
  radius,
  isAlive = true,
  deathAnimation,
  maxEnemies, -- min : 10, max : 100
  enemiePopFrequency, -- min : 0.03, max : 0.1

  init = function(self)
    self.maxEnemies = 10
    self.enemiePopFrequency = 0.03
    self.linearSpeed = 50
  end,

  new = function(self, x, y)
    local _enemy = {}

    setmetatable(_enemy, self)
    self.__index = self

    _enemy.angle = 0
    _enemy.scale = 0.03
    _enemy.deathAnimation = TableUtils.copy(boomAnimation)

    if math.random() < 0.5 then
      _enemy.radialSpeed = -0.5
    else
      _enemy.radialSpeed = 0.5
    end

    if x and y then
      _enemy.x = x
      _enemy.y = y
    else
      repeat
        _enemy.x = math.random(0, screenWidth)
        _enemy.y = math.random(0, screenHeight)
      until MathUtils.getDistance(center.x, center.y, _enemy.x, _enemy.y) > gameZoneRadius
    end



    return _enemy
  end,

  update = function(self, index, dt)

    if self.isAlive then

      -- Déplacement du virus vers le joueur
      local _relativeAngle = math.atan2(self.y - player.y, player.x - self.x)
      local _vectorV = Vector:new(self.linearSpeed, MathUtils.radsTodegrees(_relativeAngle))
      self.x = self.x + _vectorV.x * dt
      self.y = self.y + _vectorV.y * dt

      -- Rotation du virus sur lui même
      self.angle = self.angle + self.radialSpeed * dt

      -- Si le virus rentre dans la zone de jeu
      if MathUtils.getDistance(center.x, center.y, self.x, self.y) <= gameZoneRadius then

        -- Augmentation de la vitesse, NE FONCTIONNE PAS
        --if self.linearSpeed ~= self.initialLinearSpeed * 1.8 then
          --self.linearSpeed = self.linearSpeed * 1.8
        --end

        -- Augmentation de l'échelle
        if self.scale < 0.045 then
          self.scale = self.scale + 0.005
        end
      end

      -- Calcul de la hitbox du virus
      self.radius = self.texture:getWidth() * self.scale / 2

      -- Calcul de la colision avec le joueur
      if MathUtils.getDistance(self.x, self.y, player.x, player.y) < self.radius + player.radius and player.isInvincible == false then
        player:hit(index)
        table.remove(enemies, index)
      end

    else
      -- Calcul de l'animation de mort
      self.deathAnimation.currentTime = self.deathAnimation.currentTime + dt
      if self.deathAnimation.currentTime >= self.deathAnimation.duration then
          table.remove(enemies,index)
      end
      --self.deathAnimation:update(dt)
    end
  end,

  kill = function(self)
    print("I am dead !")
    local _boom = boom:clone()
    _boom:play()
    self.isAlive = false

    local points

    if MathUtils.getDistance(center.x, center.y, self.x, self.y) < gameZoneRadius then
      -- Si le virus est dans la zone de jeu
      points = 10
    else
      -- Si le virus est à l'extérieur zone de jeu
      points = 20
    end

    Player.score = Player.score + points -- le score augmente
    if gameZoneRadius > 100 then
      --gameZoneRadius = gameZoneRadius - 3 -- la zone de jeu diminue
    end

    if Player.score % 100 == 0 then -- Si le score est un multiple de 100

      if Enemy.maxEnemies < 100 then
        Enemy.maxEnemies = Enemy.maxEnemies + 2 -- Le nombre max d'enemis augmente de 10
      end

      if Enemy.linearSpeed < 200 then
        Enemy.linearSpeed = Enemy.linearSpeed + 10 -- La vitesse de base des énemis augmente de 10px/s
      end

      if Enemy.enemiePopFrequency < 0.1 then
        Enemy.enemiePopFrequency = Enemy.enemiePopFrequency + 0.01 -- La fréquence de pop des énemis augmente
      end
    end

  end,

  draw = function(self)

    love.graphics.push()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(1)

    if self.isAlive then
      love.graphics.draw(self.texture, self.x, self.y, self.angle, self.scale, self.scale, self.texture:getWidth()/2, self.texture:getHeight()/2)
      --love.graphics.circle('line', self.x, self.y, self.radius, 32)
    else
      local spriteNum = math.floor(self.deathAnimation.currentTime / self.deathAnimation.duration * #self.deathAnimation.quads) + 1
      love.graphics.draw(self.deathAnimation.spriteSheet, self.deathAnimation.quads[spriteNum], self.x - self.deathAnimation.width/2, self.y - self.deathAnimation.height/2, 0, 1)
      --self.deathAnimation:draw(0,0)
    end

    love.graphics.pop()
  end

}

return Enemy
