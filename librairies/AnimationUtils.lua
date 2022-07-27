local AnimationUtils = {

  spriteSheet,
  quads,
  duration,
  currentTime,
  width,
  height,

  new = function(self, image, width, height, duration)

    local _animation = {}

    setmetatable(_animation, self)
    self.__index = self

    _animation.spriteSheet = image;
    _animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(_animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    _animation.duration = duration or 1
    _animation.currentTime = 0

    _animation.width = width
    _animation.height = height

    return _animation

  end,

  update = function(self, dt)
    self.currentTime = self.currentTime + dt
      if self.currentTime >= self.duration then
          self.currentTime = 0
      end
  end,

  draw = function(self, x, y)
    local spriteNum = math.floor(self.currentTime / self.duration * #self.quads) + 1
    love.graphics.draw(self.spriteSheet, self.quads[spriteNum], self.x - self.width/2, self.y - self.height/2, 0, 1)
  end

}

return AnimationUtils
