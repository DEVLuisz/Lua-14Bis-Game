LARGURA_TELA = 320
ALTURA_TELA = 480
MAX_METEOROS = 16
METEOROS_ATINGIDOS = 0
METEOROS_NECESSARIOS = 100

Aviao_14bis = {
  src = 'img/14bis.png',
  Largura = 55,
  Altura = 63,
  X = LARGURA_TELA / 2 - 64 / 2,
  Y = ALTURA_TELA - 64/ 2,
  Tiros = {}
}

function DaTiro()
  Disparo:play()
  local tiro = {
    X = Aviao_14bis.X + Aviao_14bis.Largura / 2,
    Y = Aviao_14bis.Y,
    Largura = 16,
    Altura = 16
  }
  table.insert(Aviao_14bis.Tiros, tiro)
end

function MoveTiros()
  for i = #Aviao_14bis.Tiros, 1, -1 do
    if Aviao_14bis.Tiros[i].Y > 0 then
        Aviao_14bis.Tiros[i].Y = Aviao_14bis.Tiros[i].Y - 1
    else
        table.remove(Aviao_14bis.Tiros, i)
    end
  end
end

function DestroiAviao()
  Destruicao:play()
  Aviao_14bis.src = 'img/explosao_nave.png'
  Aviao_14bis.imagem = love.graphics.newImage(Aviao_14bis.src)
  Aviao_14bis.Largura = 67
  Aviao_14bis.Altura = 77
end

function TemColisao(X1, Y1, L1, A1, X2, Y2, L2, A2)
  return  X2 < X1 + L1 and
          X1 < X2 + L2 and
          Y1 < Y2 + A2 and
          Y2 < Y1 + A1
end

Meteoros = {}

function RemoveMeteoros()
  -- for i = 12, até 1, decremente 1
  for i = #Meteoros, 1, -1 do
    if Meteoros[i].Y > ALTURA_TELA then
      table.remove(Meteoros, i) 
    end
  end
end

function CriaMeteoro()
  Meteoro = {
    X = math.random(LARGURA_TELA),
    Y = - 70,
    Largura = 50,
    Altura = 44,
    Peso = math.random(3),
    Deslocamento_Horizontal = math.random(-1, 1)
  }
  table.insert(Meteoros, Meteoro)
end

function MoveMeteoros()
  for key, Meteoro in pairs(Meteoros) do
    Meteoro.Y = Meteoro.Y + Meteoro.Peso
    Meteoro.X = Meteoro.X + Meteoro.Deslocamento_Horizontal
  end
end

function Move14Bis()
  if love.keyboard.isDown('w') then
    Aviao_14bis.Y = Aviao_14bis.Y - 1
  end

  if love.keyboard.isDown('s') then
    Aviao_14bis.Y = Aviao_14bis.Y + 1
  end

  if love.keyboard.isDown('a') then
    Aviao_14bis.X = Aviao_14bis.X - 1
  end

  if love.keyboard.isDown('d') then
    Aviao_14bis.X = Aviao_14bis.X + 1
  end
end

function TrocaMusicaDeFundo()
  Musica_Ambiente:stop()
  FOI_DE_BASE:play()
end

function ChecaColisaoComAviao()
  for key, Meteoro in pairs(Meteoros) do
    if TemColisao(Meteoro.X, Meteoro.Y, Meteoro.Largura, Meteoro.Altura, Aviao_14bis.X, Aviao_14bis.Y, Aviao_14bis.Largura, Aviao_14bis.Altura) then
      TrocaMusicaDeFundo()
      DestroiAviao()
      GAME_OVER = true
    end
  end
end

function ChecaColisaoComTiros()
  for i = #Aviao_14bis.Tiros, 1, -1 do
    for j = #Meteoros, 1, -1 do
      if TemColisao(Aviao_14bis.Tiros[i].X, Aviao_14bis.Tiros[i].Y, Aviao_14bis.Tiros[i].Largura, Aviao_14bis.Tiros[i].Altura, Meteoros[j].X, Meteoros[j].Y, Meteoros[j].Largura, Meteoros[j].Altura) then
        METEOROS_ATINGIDOS = METEOROS_ATINGIDOS + 1
        table.remove(Aviao_14bis.Tiros, i)
        table.remove(Meteoros, j)
        break
      end
    end
  end
end

function CheckColisoes()
  ChecaColisaoComAviao()
  ChecaColisaoComTiros()
end

function ChecaObjetivoConcluido()
  if METEOROS_ATINGIDOS >= METEOROS_NECESSARIOS then
    WINNER_GG_EASY_PEASY_LEMON_SQUEEZY = true
    Winner_Beat:play()
    Musica_Ambiente:stop()
  end
end

-- Load some default values for our img.
function love.load()
  love.window.setMode(LARGURA_TELA, ALTURA_TELA, { resizable = false})
  love.window.setTitle('14-bis vs Meteoros')

  math.randomseed(os.time())

  Background = love.graphics.newImage('img/background.png')
  GameOver_Img = love.graphics.newImage('img/gameover.png')
  Vencedor_Img = love.graphics.newImage('img/vencedor.png')
  Aviao_14bis.imagem = love.graphics.newImage(Aviao_14bis.src)
  Meteoro_img = love.graphics.newImage('img/meteoro.png')
  Tiro_img = love.graphics.newImage('img/tiro.png')

  Musica_Ambiente = love.audio.newSource("audios/ambiente.wav", 'static')
  Musica_Ambiente:setLooping(true)
  Musica_Ambiente:play()

  Destruicao = love.audio.newSource("audios/destruicao.wav", 'static')
  FOI_DE_BASE = love.audio.newSource("audios/game_over.wav", 'static')
  Winner_Beat = love.audio.newSource("audios/winner.wav", 'static')
  Disparo = love.audio.newSource("audios/disparo.wav", 'static')
end

-- Increase the size - every frame.
function love.update(dt)
    if not GAME_OVER and not WINNER_GG_EASY_PEASY_LEMON_SQUEEZY then
      if love.keyboard.isDown('w', 'a', 's', 'd') then
        Move14Bis()
      end

      RemoveMeteoros()
      if #Meteoros < MAX_METEOROS then
        CriaMeteoro()
      end
      MoveMeteoros()
      MoveTiros()
      CheckColisoes()
      ChecaObjetivoConcluido()
    end
end

function love.keypressed(keycap)
  -- Verificando se o jogador pressionou a tecla ESC
  if keycap == 'escape' then
    love.event.quit()
  elseif keycap == 'space' then
    DaTiro()
  end
end

-- Draw 
function love.draw()
  love.graphics.draw(Background, 0, 0)
  love.graphics.draw(Aviao_14bis.imagem, Aviao_14bis.X, Aviao_14bis.Y)

  love.graphics.print('Meteoros Restantes: ' ..METEOROS_NECESSARIOS - METEOROS_ATINGIDOS, 0, 0)

  for key, Meteoro in pairs(Meteoros) do
    love.graphics.draw(Meteoro_img, Meteoro.X, Meteoro.Y)
  end

  for key, tiro in pairs(Aviao_14bis.Tiros) do
    love.graphics.draw(Tiro_img, tiro.X, tiro.Y)
  end

  if GAME_OVER then
    love.graphics.draw(GameOver_Img, LARGURA_TELA / 2 - GameOver_Img:getWidth() / 2, ALTURA_TELA / 2 - GameOver_Img:getHeight() / 2)
  end

  if WINNER_GG_EASY_PEASY_LEMON_SQUEEZY then
    love.graphics.draw(Vencedor_Img, LARGURA_TELA / 2 - Vencedor_Img:getWidth() / 2, ALTURA_TELA / 2 - Vencedor_Img:getHeight() / 2)
  end
end
