--[[

Rhythm Invasion
Daniela
Julia
Thiago
Vinicius Muza
]]



display.setDefault( "background", 100/255 )

--Adicionando física
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )
physics.setScale( 60 )


-- definição das fronteiras as quais a bola não pode passar baseado nas posições de origem
local screenTop = display.screenOriginY
local screenBottom = display.viewableContentHeight + display.screenOriginY
local screenLeft = display.screenOriginX
local screenRight = display.viewableContentWidth + display.screenOriginX


--retangulo de area de jogo
local sqRect = display.newRect( 0, 0, display.contentWidth, screenBottom-70 )
sqRect.anchorX, sqRect.anchorY = 0.0, 0.0 	-- simulate TopLeft alignment
sqRect:setFillColor( 50/255, 50/255, 0/255, 170/255 )

--barra para calcular a colisão
local barraColisao = display.newRect( 0, screenBottom-150, display.contentWidth, 20 )
barraColisao.anchorX, barraColisao.anchorY = 0.0, screenBottom-150 
barraColisao:setFillColor( 0/255, 55/255, 55/255, 170/255 )
barraColisao.myName = "Barra de Colisão"
physics.addBody( barraColisao, "static", { density=0.0, friction=0.0, bounce=0.0 } )

--linha para PERFECTS apenas ajuda visual para o jogador
local linhaMeioColisao = display.newRect( 0, screenBottom-159, display.contentWidth, 1 )
linhaMeioColisao.anchorX, linhaMeioColisao.anchorY = 0.0, screenBottom-159 
linhaMeioColisao:setFillColor( 0/255, 9/255, 255/255, 255/255 )
linhaMeioColisao = "Linha de Colisão"

--guidelines das naves
local guideline1 = display.newRect( display.contentWidth/5, 0, 1, display.contentHeight-159 )
guideline1.anchorY = 0 
guideline1:setFillColor( 0/255, 9/255, 255/255, 255/255 )
guideline1.myName = "Guideline 1"

local guideline2 = display.newRect( display.contentWidth*2/5, 0, 1, display.contentHeight-159 )
guideline2.anchorY = 0 
guideline2:setFillColor( 0/255, 9/255, 255/255, 255/255 )
guideline2.myName = "Guideline 2"

local guideline3 = display.newRect( display.contentWidth*3/5, 0, 1, display.contentHeight-159 )
guideline3.anchorY = 0 
guideline3:setFillColor( 0/255, 9/255, 255/255, 255/255 )
guideline3.myName = "Guideline 3"

local guideline4 = display.newRect( display.contentWidth*4/5, 0, 1, display.contentHeight-159 )
guideline4.anchorY = 0 
guideline4:setFillColor( 0/255, 9/255, 255/255, 255/255 )
guideline4.myName = "Guideline 4"

local linhas = {guideline1, guideline2, guideline3,guideline4 }

--Label para indicar o que está acontecendo
local label = display.newText( "Atividade Atual:", 0, 0,system.systemFont, 16)
label.x = screenLeft+5
label.y = display.contentHeight-40
label.align="left"
label.anchorX=0.0

-- Label para contagem de teclas apertadas
local txtTeclas = "Teclas :"
local qtdTeclasApertadas = 0
--Label para indicar o que está acontecendo
local qtdClicks = display.newText( "Teclas: ", 0, 0,system.systemFont, 16)
qtdClicks.x = screenLeft+5
qtdClicks.y = display.contentHeight-60
qtdClicks.align="left"
qtdClicks.anchorX=0.0




local optionsTorpedos = 
{
	 frames =
    {
        -- FRAME 1:
        {
            --all parameters below are required for each frame
            x = 250,
            y = 77,
            width = 14,
            height = 65,            
        },
        -- FRAME 2:
        {
            --all parameters below are required for each frame
            x = 236,
            y = 77,
            width = 14,
            height = 65,            
        },
        -- FRAME 3:
        
        {
            --all parameters below are required for each frame
            x = 222,
            y = 77,
            width = 14,
            height = 65,            
        },

        
    },
	
}

local sheet = graphics.newImageSheet( "54916.png", optionsTorpedos )

-- Codigo para criação de Torpedos
local function fireTorpedo(playerOwner, tipoTiro)
	local sequence = { name="Torpedo", start=1,count=3,  time=1000}
	local sprite = display.newSprite( sheet, sequence )
	sprite.x=playerOwner.x
	sprite.y=playerOwner.y
	sprite:play()
	sprite.myName = "torpedo"
  if tipoTiro=="GREEN" then
    sprite:setFillColor( 0,255,0 )
  elseif tipoTiro=="RED" then
    sprite:setFillColor( 255,0,0 )
  elseif   tipoTiro=="BLUE" then
    sprite:setFillColor( 0,0, 255 )
  end

  sprite.tipo = tipoTiro -- identifica o tipo deo tiro para comparar com a nave. tem que combinar
  physics.addBody( sprite, "static",{density=0.0, friction=0.0, bounce=0.0 } )
  return sprite
end

--Animação da explosão

local optionsExplosion = 
{
	 frames =
    {
        -- FRAME 1:
        {
            --all parameters below are required for each frame
            x = 62,
            y = 118,
            width = 17,
            height = 17,            
        },
        -- FRAME 2:
        {
            --all parameters below are required for each frame
            x = 101,
            y = 113,
            width = 28,
            height = 28,            
        },
        -- FRAME 3:
        
        {
            --all parameters below are required for each frame
            x = 132,
            y = 111,
            width = 32,
            height = 32,            
        },

        --frame 4
  		{
            --all parameters below are required for each frame
            x = 167,
            y = 110,
            width = 34,
            height = 34,            
        },      
    },
	
}

local sheetExplosion = graphics.newImageSheet( "54916.png", optionsExplosion )

-- Codigo para explosão de Torpedos
local function explode(obj1, obj2)
	local sequence = { name="explosao",start=1,count=4,  time=500, loopCount=1, loopDirection = "bounce" }
	local sprite = display.newSprite( sheetExplosion, sequence)
	sprite.x=obj2.x
	sprite.y=obj2.y 

	sprite:play()
	sprite.myName = "Explosion"
	 
	return sprite
end


--retângulo movimentado manualmente
--Codigo alterado para inserir sprites ao inves de um quadrado
--local player1 = display.newRect( screenLeft, 20, 30, 30 )
--player1.strokeWidth = 3
--player1:setFillColor( 30, 200, 10, 255 )
--player1:setStrokeColor( 1, 0, 0 )

local function createPlayer(whereX, whereY)
	local optionsPlayer = 
	{
		frames =
	    {
	        -- FRAME 1:
	        {
	            --all parameters below are required for each frame
	            x = 9,
	            y = 9,
	            width = 28,
	            height = 28,            
	        },
	        -- FRAME 2:
	        {
	            --all parameters below are required for each frame
	            x = 39,
	            y = 9,
	            width = 23,
	            height = 28,            
	        },
	        -- FRAME 3:
	        
	        {
	            --all parameters below are required for each frame
	            x = 65,
	            y = 9,
	            width = 15,
	            height = 28,            
	        },   
	    },
		
	}

	local sheetPlayer = graphics.newImageSheet( "54916.png", optionsPlayer )
	local sequence = { name="Nave", start=1,count=3,  time=1000}
	local sprite = display.newSprite( sheetPlayer, sequence )
	sprite.myName = "Player 1"
	sprite.x=whereX
	sprite.y=whereY	
	--sprite:play()
	physics.addBody( sprite, "static",{density=1.0, friction=0.0, bounce=0.0 } )
	return sprite
end

local player1 = createPlayer(guideline1.x,screenBottom-100)

local torpedosLancados = {}

-- So cuida da animação dos torpedos
local function handleTorpedo( event )
     
	if (#torpedosLancados>0) then
		local torpedosCleanup={}
		for i=1,#torpedosLancados,1 do
			--o torpedo so vai chegar até o final da barra de colisão
			if(torpedosLancados[i].y<barraColisao.y+5) then
				torpedosLancados[i]:pause()	
				torpedosCleanup[#torpedosCleanup+1]=i			
			end			
			torpedosLancados[i]:translate( 0, -10 )			 			
		end
		for i=1,#torpedosCleanup,1 do
			torpedosLancados[torpedosCleanup[i]]:removeSelf()
			table.remove( torpedosLancados,torpedosCleanup[i] )
		end
	end
end


local currentGrid = 1 --indica qual a posição em que o jogador esta, ele podera mover do 4 para o 1 e vice versa


-- função chamada quando uma tecla e pressionada
local function onKeyEvent( event )
--	
if (event.phase=="down") then
		
	if (event.keyName == "a")  or (event.keyName == "left") then
		currentGrid=currentGrid-1
    if currentGrid==0 then 
      currentGrid=4
    end
	end
	
	if (event.keyName == "d") or (event.keyName == "right") then
		currentGrid=currentGrid+1
    if currentGrid==5 then 
      currentGrid=1
    end
	end
  
  -- Move o jogador para o grid
  player1.x = linhas[currentGrid].x
  
  --alterar para modificar a cor dos torpedos
  local tipo = ""
  if (event.keyName=="r") then
		tipo="RED"
	elseif(event.keyName=="g") then
    tipo="GREEN"
  elseif (event.keyName=="b") then
    tipo="BLUE"  
  end
  if tipo~="" then
      torpedosLancados[#torpedosLancados + 1] = fireTorpedo(player1,tipo)
  end
end
		
end


local explosionsToClean = {}

local function cleanObjects(event)
	for _,item in ipairs( explosionsToClean ) do
		if(item.isPlaying==false) then
			item:removeSelf()
			
		end
	end	
end


--detector de colisões
local function onGlobalCollision( event )
	if ( event.phase == "began" ) then

		print( "Global report: " .. event.object1.myName .. " & " .. event.object2.myName .. " collision began" )
	elseif ( event.phase == "ended" ) then

		print( "Global report: " .. event.object1.myName .. " & " .. event.object2.myName .. " collision ended" )

	end


	local explosion = explode(event.object1,event.object2)
	--	é preciso destruir a animacao de explosoes e os objetos mortos
	explosionsToClean[#explosionsToClean+1] = explosion
	print( "**** " .. event.element1 .. " -- " .. event.element2 )
	
end

-- para carregar a musica seria bom fazer uma tela de ...loading...
local audioLoaded = audio.loadSound( "corona.mp3" )
timer.performWithDelay( 4000, audio.play( audioLoaded, { channel = 1, loops = 1} ),1)

-- gerador de nível
--carregar arquivo de padrao de naves level propriamente dito
local filePath = system.pathForFile( "RhythmInvasion_corona.txt" )
local levelShips ={} 

for line in io.lines(filePath) do
	levelShips[#levelShips+1] = line
end
--[[
o arquivo deve conter
1-4 RGB 123
1-4 é a posição da nave no grid
RGB é a COR
123 é o tipo da nave, atualmente só temos 1 e 2
linha em branco significa sem naves naquele espaço
]]



-- a criação dos objetos sera baseado em beats per minute
local tempo=60 -- in BPM
local tempoMS=60000/tempo/2 -- cada linha sera meio tempo em 4/4
local timerLocal = system.getTimer -- para melhorar o desempenho da funcao timer 
local timestarted=timerLocal() --tempo inicial do jogo
local proximaLinha=timestarted+tempoMS
local currentLevelLine = 1
local navesCriadas = {}


local function criaNave(tipoNave)
	if tipoNave~="" then
		local novaNave = display.newImage(tipoNave:sub(2)..".jpg", linhas[tonumber(tipoNave:sub(1,1))].x , 0)
		--é preciso combinar o tamanho das naves
		novaNave:scale(.3,.3)
		novaNave.myName = tipoNave:sub(2)

		-- Colisor ainda nao esta funcionando
		--physics.addBody( novaNave, {density=0.0, friction=0.0, bounce=0.0 } )
		navesCriadas[#navesCriadas+1] = novaNave
		
	end 
end



local function handleShips( event )
   	--inicialmente as naves terao um movimento fluido.
   	--caso queira ter um movimento ritmado, basta por este codigo dentro do if de timing abaixo
   	local navesCleanup={}
	for i=1,#navesCriadas,1 do
		--a nave so vai chegar até o final da barra de colisão
		if(navesCriadas[i].y>barraColisao.y) then
			navesCleanup[#navesCleanup+1]=i
			else
			navesCriadas[i]:translate( 0, 3 )				
		end			
					 			
	end
	for i=1,#navesCleanup,1 do
		navesCriadas[navesCleanup[i]]:removeSelf()
		table.remove( navesCriadas,navesCleanup[i] )
	end

   local thetime = timerLocal()
   local index=math.max(0,16-(math.floor(thetime-proximaLinha)))  

   --If de timing para comparar o tempo atual com a proxima batida.
   if thetime>proximaLinha then
      
      -- Criar novas naves
    if currentLevelLine<=#levelShips then
      	criaNave(levelShips[currentLevelLine])
      	currentLevelLine=currentLevelLine+1
  	end 


      --Begin playback integrity check
      if thetime>proximaLinha+tempoMS then -- i.e. we are behind two beats because of some kind of overload
        print("OH NO! Tempo has gone out of phase due to an interruption in the runtime or perhaps the audio engine, etc")
        --playback could be halted here, too
      end 
      --End playback integrity check
 
      proximaLinha=proximaLinha+tempoMS
      
   end

end

-- Ouvintes de eventos monitorados quadro a quadro
Runtime:addEventListener( "key", onKeyEvent )
Runtime:addEventListener( "enterFrame", cleanObjects );
Runtime:addEventListener( "collision", onGlobalCollision )
Runtime:addEventListener( "enterFrame", handleTorpedo )
Runtime:addEventListener( "enterFrame", handleShips )

