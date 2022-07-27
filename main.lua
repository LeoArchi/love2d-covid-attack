Enemy = require "enemy"

CENTER={}
SCREEN={}

enemies = {}
missiles = {}

life = 3

points = 0

invincibilityTimer = 0

easeOutTimer = 0

missileCoolDown = 0

buffEnemy = false

maxEnemies = 10

local function sizeOf(table)
  local _size = 0

  for i, v in ipairs(table) do
    _size = _size + 1
  end

  return _size
end

function table.shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

function easeOutBack(x)
  local c1 = 1.70158;
  local c3 = c1 + 1;

  return 1 + c3 * math.pow(x - 1, 3) + c1 * math.pow(x - 1, 2);
end

function love.keypressed(key, scancode, isrepeat)
  if key == "r" then

  end
end

function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    animation.width = width
    animation.height = height

    return animation
end

function love.load()

  love.mouse.setVisible(false)

  marsTheme = love.audio.newSource("mars.wav", "stream")
  marsTheme:setLooping(true)
  marsTheme:setVolume(3)
  marsTheme:play()

  piou = love.audio.newSource("piou.wav", "static")
  piou:setVolume(0.25)

  cougth = love.audio.newSource("cought.wav", "static")
  cougth:setVolume(0.6)

  boum = love.audio.newSource("boum.wav", "static")
  boum:setVolume(0.4)

  covid = love.graphics.newImage("covid.png")

  background = love.graphics.newImage("lungs-v2.png")

  lifeHeart = love.graphics.newImage("lungs life.png")

  boomAnimation = newAnimation(love.graphics.newImage("explosion.png"), 192, 192, 1)

  seringue = love.graphics.newImage("seringue.png")
  vaccine = love.graphics.newImage("vaccine drop.png")

  defaultFont = love.graphics.newFont("GreatVibes-Regular.otf",25)
  titleFont = love.graphics.newFont("GreatVibes-Regular.otf",50)

  SCREEN.width = love.graphics.getWidth()
  SCREEN.height = love.graphics.getHeight()

  CENTER.x = SCREEN.width/2
  CENTER.y = SCREEN.height/2

  PLAYER = {}
end


function love.update(dt)

  easeOutTimer = easeOutTimer + dt*2.5
  if easeOutTimer >= 1 then
    easeOutTimer = easeOutTimer - 1
  end

  if love.mouse.isDown(1) and missileCoolDown == 0 then
    missileCoolDown = 0.15
    if sizeOf(missiles) < 500 then
      local _missile = {}
      _missile.x = love.mouse.getX()
      _missile.y = love.mouse.getY()

      table.insert(missiles, _missile)
      local _piou = piou:clone()
      _piou:play()

    end
  end

  missileCoolDown = missileCoolDown - dt
  if missileCoolDown <= 0 then
    missileCoolDown = 0
  end

  titleScaleFactor = easeOutBack(easeOutTimer) *2

  if life > 0 then

    if invincibilityTimer > 0 then
      invincibilityTimer = invincibilityTimer - dt
    else
      invincibilityTimer = 0
    end

    PLAYER.x = love.mouse.getX()
    PLAYER.y = love.mouse.getY()

    for index, missile in ipairs(missiles) do
      missile.y = missile.y - 300 * dt
      if missile.y <= 0 then
        table.remove(missiles, index)
      end
    end

    if math.random() < 0.03 and sizeOf(enemies)<maxEnemies then

      local _randomX = math.random(0, love.graphics.getWidth())
      local _randomY = math.random(0, love.graphics.getHeight())

      local _newEnemy = Enemy:new(_randomX,_randomY)

      table.insert(enemies, _newEnemy)
    end

    for indexEnemy, enemy in ipairs(enemies) do
      enemy:update(indexEnemy, dt)

      -- On teste les collisions
      for indexMissile, missile in ipairs(missiles) do
        if math.sqrt(math.pow(missile.x-enemy.x, 2) + math.pow(missile.y-enemy.y, 2)) <= (17 + 5) then -- 17 le rayon du covid + 5 le rayon du vaccin
          enemy:destroy(indexEnemy)
          table.remove(missiles, indexMissile)
          points = points + 10

          if points % 100 == 0 and points > 0 and buffEnemy == false then
            print('buffEnemy')
            buffEnemy = true
          end

        end
      end
    end



  end
end

function love.draw()

  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.draw(background, 0, 0, 0, 1/(background:getWidth()/love.graphics.getWidth()), 1/(background:getHeight()/love.graphics.getHeight()))

  titleDrawable = love.graphics.newText( titleFont, "Super covid-19 Attack !" )
  love.graphics.draw(titleDrawable, love.graphics.getWidth()/2 - titleDrawable:getWidth()*titleScaleFactor/2 , 20, 0, titleScaleFactor, titleScaleFactor)

  love.graphics.setFont(defaultFont)

  if life > 0 then

    love.graphics.setColor(0, 1, 0, 1)
    for index, missile in ipairs(missiles) do
      love.graphics.circle('fill', missile.x, missile.y, 5, 16)
    end

    love.graphics.setColor(1, 1, 1, 1)
    for i=0,life-1 do
      love.graphics.draw(lifeHeart, 10 + i*0.15*lifeHeart:getWidth(), 10, 0, 0.15, 0.15)
    end

    love.graphics.print("Score : " .. points, 10, 100)


    if invincibilityTimer > 0 then
      love.graphics.setColor(1, 1, 1, 0.3)
    else
      love.graphics.setColor(1, 1, 1, 1)
    end
    --love.graphics.polygon('fill', PLAYER.x, PLAYER.y-20, PLAYER.x-10, PLAYER.y+20, PLAYER.x, PLAYER.y+15, PLAYER.x+10, PLAYER.y+20)
    love.graphics.draw(seringue, PLAYER.x, PLAYER.y, 0, 0.05, 0.05, seringue:getWidth()/2, 500)

    for index, enemy in ipairs(enemies) do
      enemy:draw()
    end
  else
    love.graphics.setColor(1, 1, 1, 1)
    gameoverDrawable = love.graphics.newText( titleFont, "Game Over" )
    finalScoreDrawable = love.graphics.newText( titleFont, "Your score : " .. points )
    love.graphics.draw(gameoverDrawable, love.graphics.getWidth()/2 - gameoverDrawable:getWidth()/2, love.graphics.getHeight()/2 - gameoverDrawable:getHeight()/2)
    love.graphics.draw(finalScoreDrawable, love.graphics.getWidth()/2 - finalScoreDrawable:getWidth()/2, love.graphics.getHeight()/2 - finalScoreDrawable:getHeight()/2 + gameoverDrawable:getHeight() + 20)
  end
end
