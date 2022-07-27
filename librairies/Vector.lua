local Vector = {

  norm,
  angle,
  x,
  y,

  -- norm : norme du vecteur en pixels
  -- angle : angle du vecteur en degrés, celon le cercle trigonométrique
  new = function(self, norm, angle)

    -- Si la norme est négative, inverser l'angle (+180°)
    if norm < 0 then
      angle = MathUtils.capAngle(angle + 180)
    end

    local _vector = {}

    setmetatable(_vector, self)
    self.__index = self

    local _angleRads = MathUtils.degreesToRads(angle)

    _vector.norm = math.abs(norm)
    _vector.angle = angle
    _vector.x = math.cos(_angleRads) * norm
    _vector.y = - math.sin(_angleRads) * norm

    return _vector
  end,

  add = function(self, vectorB)

    local _newVector = {}

    setmetatable(_newVector, Vector)
    Vector.__index = Vector

    _newVector.x = self.x + vectorB.x
    _newVector.y = self.y + vectorB.y
    _newVector.norm = math.sqrt(math.pow(_newVector.x, 2) + math.pow(_newVector.y, 2))
    _newVector.angle = MathUtils.capAngle(MathUtils.radsTodegrees(math.atan2(-_newVector.y, _newVector.x)))

    return _newVector

  end,

  -- add angle
  addAngle = function(self, angle)

    self.angle = MathUtils.capAngle(self.angle + angle)

    local _angleRads = MathUtils.degreesToRads(self.angle)
    self.x = math.cos(_angleRads) * self.norm
    self.y = - math.sin(_angleRads) * self.norm

  end,

  --add norme
  addNorm = function(self,norm)

    if self.norm + norm <= 0 then
      self.norm = 0
    else
      self.norm = self.norm + norm
    end

    self.angle = self.angle

    local _angleRads = MathUtils.degreesToRads(_newVector.angle)
    self.x = math.cos(_angleRads) * self.norm
    self.y = - math.sin(_angleRads) * self.norm

  end

}

return Vector
