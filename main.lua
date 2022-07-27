Vector = require("librairies/Vector")
MathUtils = require("librairies/MathUtils")
TableUtils = require("librairies/TableUtils")
AnimationUtils = require("librairies/AnimationUtils")

Player = require("player")
Projectile = require("projectile")
Enemy = require("enemy")
HUD = require("hud")

function love.load()

  -- CHARGEMENT DES SONS
  theme = love.audio.newSource("resources/audio/mars.wav", "stream")
  theme:setLooping(true)
  theme:setVolume(1)
  --theme:play()

  piou = love.audio.newSource("resources/audio/piou.wav", "static")
  piou:setVolume(0.1)

  cougth = love.audio.newSource("resources/audio/cought.wav", "static")
  cougth:setVolume(0.6)

  boom = love.audio.newSource("resources/audio/boum.wav", "static")
  boom:setVolume(0.2)

  gameOver = love.audio.newSource("resources/audio/game-over.wav", "static")
  gameOver:setVolume(1)

  bomb = love.audio.newSource("resources/audio/bomb.wav", "static")

  -- CHARGEMENT DES IMAGES
  boomAnimation = AnimationUtils:new(love.graphics.newImage("resources/images/explosion.png"), 192, 192, 1)
  background = love.graphics.newImage("resources/images/background.png")
  titleBackground = love.graphics.newImage("resources/images/title-background.jpg")
  gameOverBackground = love.graphics.newImage("resources/images/game-over-background.jpg")

  lungs = love.graphics.newImage("resources/images/lungs.png")

  -- CHARGEMENT DES FONTS
  titleFont = love.graphics.newFont(50)
  normalFont = love.graphics.newFont(20)

  -- INITIALISATION DES TEXTE
  titleText = love.graphics.newText( titleFont, "COVID-19 ATTACK !" )
  gameOverText = love.graphics.newText( titleFont, "GAME OVER" )

  math.randomseed(os.time())

  love.mouse.setVisible(false)

  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()

  center = {}
  center.x = screenWidth/2
  center.y = screenHeight/2

  gameZoneRadius = 320


  -- Initialisation du joueur
  Player:init()
  player = Player:new(center.x, center.y)


  projectiles = {}

  -- Initialisation des ennemis
  Enemy:init()
  enemies = {}

end

-- TEMPORAIRE, GESTION DE L'EFFET SONORE GAME OVER
local _gameOverTriggered = false

-- TEMPORAIRE, GESTION DE L'ECRAN TITRE
local _titleScreen = true

function love.update(dt)

  if player.life ~= 0 and _titleScreen == false then
    -- Mise à jour du joueur
    player:update(dt)

    -- Mise à jour des projectiles tirés
    for index, projectile in ipairs(projectiles) do
      projectile:update(index, dt)
    end

    -- Pop d'un nouvel enemi
    if math.random() < Enemy.enemiePopFrequency and TableUtils.sizeOf(enemies) < Enemy.maxEnemies then
      local _enemy = Enemy:new()
      table.insert(enemies, _enemy)
    end

    for index, enemy in ipairs(enemies) do
      enemy:update(index, dt)
    end
  elseif _gameOverTriggered == false and _titleScreen == false then
    projectiles = {}
    enemies = {}
    theme:stop()
    gameOver:play()
    _gameOverTriggered = true
  end

end

function love.draw()

  if _titleScreen == true then
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(titleBackground, 0, 0, 0, 1/(titleBackground:getWidth()/love.graphics.getWidth()), 1/(titleBackground:getHeight()/love.graphics.getHeight()))
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.draw(titleText, love.graphics.getWidth()/2 - titleText:getWidth()/2, love.graphics.getHeight()/2 - titleText:getHeight()/2)
  elseif player.life ~= 0 then
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(background, 0, 0, 0, 1/(background:getWidth()/love.graphics.getWidth()), 1/(background:getHeight()/love.graphics.getHeight()))

    love.graphics.setLineWidth(5)
    love.graphics.setColor(1, 1, 1, 0.3)
    love.graphics.circle('fill', center.x, center.y, gameZoneRadius, 128)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('line', center.x, center.y, gameZoneRadius, 128)

    for index, enemy in ipairs(enemies) do
      enemy:draw()
    end

    for index, projectile in ipairs(projectiles) do
      projectile:draw()
    end

    player:draw()

    HUD.draw()
  else
    local _finalScoreText = love.graphics.newText( normalFont, "Score : " .. player.score )
    local _totalHeight = gameOverText:getHeight() + _finalScoreText:getHeight()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gameOverBackground, 0, 0, 0, 1/(gameOverBackground:getWidth()/love.graphics.getWidth()), 1/(gameOverBackground:getHeight()/love.graphics.getHeight()))
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.draw(gameOverText, love.graphics.getWidth()/2 - gameOverText:getWidth()/2, love.graphics.getHeight()/2 - _totalHeight/2)
    love.graphics.draw(_finalScoreText, love.graphics.getWidth()/2 - _finalScoreText:getWidth()/2, love.graphics.getHeight()/2 + _totalHeight/2)
  end

end

function love.keypressed(key, scancode, isrepeat)
  if key == "return" then
    print("enter")
    if _titleScreen == true and _gameOverTriggered == false then

      -- Réinitialisation du joueur
      Player:init()

      -- Réinitialisation des l'ennemis
      Enemy:init()

      theme:play()
      _titleScreen = false
    elseif _titleScreen == false and _gameOverTriggered == true then
        _gameOverTriggered = false
        _titleScreen = true
    end
  end
end
