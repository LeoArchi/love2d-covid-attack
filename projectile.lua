local Projectile = {

  x,
  y,
  radius,
  vector,

  new = function(self, x, y, vector)
    local _projectile = {}

    setmetatable(_projectile, self)
    self.__index = self

    _projectile.x = x
    _projectile.y = y
    _projectile.radius = 10
    _projectile.vector = vector

    return _projectile
  end,

  newBomb = function(self, x, y)
    local _bombSound = bomb:clone()
    _bombSound:play()
    for angle=0,360,5 do
      local _projectile = self:new(x, y, Vector:new(500, angle)) -- La vitesse du projectile est ici réglée à 500px/s
      table.insert(projectiles, _projectile)
    end
    Player.bombCooldown = 1
  end,

  update = function(self, p_index, dt)

    self.x = self.x + self.vector.x * dt
    self.y = self.y + self.vector.y * dt

    if self.x > screenWidth or self.x < 0 or self.y > screenHeight or self.y < 0 then
      table.remove(projectiles, p_index)
    end

    -- Si le projectile sort de la zone de jeu, il devient plus petit
    if MathUtils.getDistance(center.x, center.y, self.x, self.y) > gameZoneRadius then
      self.radius = 5
    end

    -- Tester les collisions
    for e_index, enemy in ipairs(enemies) do
      if enemy ~= nil and self ~= nil then
        if MathUtils.getDistance(enemy.x, enemy.y, self.x, self.y) < self.radius + enemy.radius and enemy.isAlive then
          enemy:kill()
          table.remove(projectiles, p_index)
        end
      end
    end

  end,

  draw = function(self)

    love.graphics.push()

    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.circle('fill', self.x, self.y, self.radius, 32)

    love.graphics.pop()
  end


}

return Projectile
