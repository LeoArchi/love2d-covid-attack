local TableUtilities = {
  sizeOf = function(table)
    local _size = 0

    for i, v in ipairs(table) do
      _size = _size + 1
    end

    return _size
  end,

  copy = function(table)
    local copy = {}
    for key, value in pairs(table) do
      copy[key] = value
    end
    return copy
  end
}

return TableUtilities
