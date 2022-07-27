local MathUtilities = {

  getDistance = function(x1,y1,x2,y2)
    return math.sqrt(math.pow(x1-x2, 2) + math.pow(y1-y2, 2))
  end,

  degreesToRads = function(angle)
    local _radsAngle = angle * math.pi / 180
    return _radsAngle
  end,

  radsTodegrees = function(angle)
    local degreesAngle = angle * 180 / math.pi
    return degreesAngle
  end,

  -- If an angle is >=360° or <0°, return the correspondant angle between 0° and 359°
  capAngle = function(angle)

    local _capedAngle = angle

    if _capedAngle >= 360 then
      _capedAngle = _capedAngle - 360
    elseif _capedAngle < 0 then
      _capedAngle = _capedAngle + 360
    end

    return _capedAngle
  end

}

return MathUtilities
