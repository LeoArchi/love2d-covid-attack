HUD = {


  draw = function()

    love.graphics.setColor(1, 1, 1, 1)
    for i=0,Player.life-1 do
      love.graphics.draw(lungs, 10 + i*0.15*lungs:getWidth(), 10, 0, 0.15, 0.15)
    end

    local _score = love.graphics.newText( normalFont, "Score : " .. player.score )
    love.graphics.draw(_score, 10, 100)

  end

}

return HUD
