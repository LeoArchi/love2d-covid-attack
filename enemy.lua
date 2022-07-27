Enemy = {

  x,
  y,
  speed = 50,
  deathAnimation = nil,
  angle = 0,

  new = function(self, x, y)

    local _enemy = {}

    setmetatable(_enemy, self)
    self.__index = self

    _enemy.x = x
    _enemy.y = y

    return _enemy

  end,

  destroy = function(self, index)

    if self.deathAnimation == nil then
      print("destoy enemy")
      --table.remove(enemies,index)
      local _boum = boum:clone()
      _boum:play()

      self.deathAnimation = table.shallow_copy(boomAnimation)
    end
  end,

  destroyByDamage = function(self, index)
    print("destoy enemy")
    table.remove(enemies,index)
  end,

  update = function(self, index, dt)

    self.angle = self.angle + 15 * dt * math.pi / 180

    if self.angle >= math.pi * 2 then
      self.angle = self.angle - math.pi * 2
    end

    if self.deathAnimation == nil then
      local _angle = math.atan2(self.y - PLAYER.y, PLAYER.x - self.x)

      if buffEnemy then
        buffEnemy = false
        Enemy.speed = Enemy.speed + 20
        maxEnemies = maxEnemies+5
        print('enemy buffed')
      end

      self.x = self.x + math.cos(_angle) * Enemy.speed * dt
      self.y = self.y - math.sin(_angle) * Enemy.speed * dt

      if math.sqrt(math.pow(self.x - PLAYER.x, 2) + math.pow(self.y - PLAYER.y, 2)) < 17 and invincibilityTimer == 0 then
        print("Touch")
        life = life - 1
        local _cougth = cougth:clone()
        _cougth:play()
        invincibilityTimer = 3
        self:destroyByDamage(index)
      end
    else
      self.deathAnimation.currentTime = self.deathAnimation.currentTime + dt
      if self.deathAnimation.currentTime >= self.deathAnimation.duration then
          table.remove(enemies,index)
      end
    end
  end,

  draw = function(self)

    local _scale = 0.04

    --love.graphics.setColor(1, 0.5, 0, 1)

    if self.deathAnimation == nil then
      love.graphics.setColor(1, 1, 1, 1)
      --love.graphics.draw(covid, self.x - covid:getWidth()*_scale/2 , self.y - covid:getHeight()*_scale/2, self.angle, _scale, _scale)
      love.graphics.draw(covid, self.x - covid:getWidth()*_scale/2, self.y - covid:getHeight()*_scale/2, 0, _scale, _scale, 0, 0)
      --love.graphics.circle('fill', self.x, self.y, 17, 16)
    else
      love.graphics.setColor(1, 1, 1, 1)
      local spriteNum = math.floor(self.deathAnimation.currentTime / self.deathAnimation.duration * #self.deathAnimation.quads) + 1
      love.graphics.draw(self.deathAnimation.spriteSheet, self.deathAnimation.quads[spriteNum], self.x - self.deathAnimation.width/2, self.y - self.deathAnimation.height/2, 0, 1)
    end




  end

}

return Enemy
