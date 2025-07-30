-- Lotería customizable
local LOTTERY_NPC_ID = 1111 -- Reemplaza con el ID del NPC de la lotería
local BET_COST = 1000000 -- 100 monedas de oro (10000 cobre = 1 oro)
local WIN_REWARD = 25000000 -- 250 monedas de oro (25000 cobre = 1 oro)
local TOKEN_ID = 11111 -- ID del ítem Token a otorgar puede ser Triunfo/Escarcha/Etcétera
local TOKEN_AMOUNT = 25 -- Cantidad de tokens a otorgar
local ITEM_REWARD_ID = 43599 -- ítem a otorgar puede ser Montura 43599 (MonturaOsoBlizzard)
local ITEM_REWARD_AMOUNT = 1 -- Cantidad del nuevo ítem a otorgar
local winningNumber = math.random(1, 20)
local playersBets = {}
local RESET_INTERVAL = 3600 -- 24 horas en segundos (ajústal según la need de tu server)
local startTime = nil
local firstMessageShown = false
local lastWinner = nil

-- Función para iniciar el evento de lotería
local function IniciarLoteria()
    winningNumber = math.random(1, 20)
    playersBets = {}
    firstMessageShown = false
    lastWinner = nil
    SendWorldMessage("¡El número ganador de la lotería se ha restablecido!")
end

-- Función para manejar las apuestas de los jugadores
local function HacerApuesta(player, number)
    local accountId = player:GetAccountId()
    local characterGUID = player:GetGUID()

    if playersBets[accountId] then
        player:SendBroadcastMessage("Ya has realizado una apuesta para esta ronda. Solo puedes apostar una vez por evento.")
        return
    end

    if player:GetCoinage() >= BET_COST then
        player:ModifyMoney(-BET_COST)
        playersBets[accountId] = { guid = characterGUID, number = number }
        player:SendBroadcastMessage("|TInterface\\ICONS\\INV_Misc_Coin_01:30|t Usted ha apostado por el número " .. number .. ". ¡Espere a los resultados!")

        -- Mostrar anuncio global una sola vez cuando un jugador apuesta por el número
        if not firstMessageShown then
            SendWorldMessage("|cffff0000|Hspell:60488|h[¡Lotería en Servidor!]|h|r Se ha iniciado la primera apuesta, los resultados serán anunciados y reseteados cada 1 hora. ¡Buena suerte!")
            firstMessageShown = true
            startTime = os.time() -- Iniciar el temporizador al hacer la primera apuesta
        end

        if number == winningNumber then
            player:ModifyMoney(WIN_REWARD)
            player:AddItem(TOKEN_ID, TOKEN_AMOUNT)
            player:AddItem(ITEM_REWARD_ID, ITEM_REWARD_AMOUNT)
            player:SendBroadcastMessage("¡Felicidades! Has ganado la lotería con el número " .. number .. " y has recibido " .. WIN_REWARD / 10000 .. " monedas de oro, " .. TOKEN_AMOUNT .. " FirecrownWow tokens y " .. ITEM_REWARD_AMOUNT .. " ítem(s) adicional(es).")
            lastWinner = player:GetName()
        end
    else
        player:SendBroadcastMessage("No tienes suficiente oro para realizar esta apuesta.")
    end
end

-- Función para mostrar el menú de apuestas del NPC
local function OnGossipHello(event, player, object)
    player:GossipMenuAddItem(0, "|TInterface\\ICONS\\INV_Misc_Coin_01:30|t Bienvenidos al sorteo del Servidor. Las apuestas son de 100 de oro y como recompensas si ganas obtendrás 250 más 25 Tokens y Montura Oso de la Blizzard", 0, 1001)
    for i = 1, 20 do
        player:GossipMenuAddItem(0, "|TInterface\\ICONS\\inv_misc_note_05:30|t Número " .. i, 0, i)
    end
    player:GossipSendMenu(1, object)
end

-- Función para manejar la selección del menú de apuestas del NPC
local function OnGossipSelect(event, player, object, sender, intid, code, menu_id)
    if intid >= 1 and intid <= 20 then
        HacerApuesta(player, intid)
    end
    player:GossipComplete()
end

-- Registrar eventos
RegisterCreatureGossipEvent(LOTTERY_NPC_ID, 1, OnGossipHello)
RegisterCreatureGossipEvent(LOTTERY_NPC_ID, 2, OnGossipSelect)

-- Iniciar el primer evento de lotería
IniciarLoteria()

-- Bucle de verificación de tiempo para reiniciar la lotería cada 24 horas
local function CheckTime()
    if startTime and os.time() - startTime >= RESET_INTERVAL then
        if lastWinner then
            SendWorldMessage("¡El jugador ganador de la lotería en este día ha sido " .. lastWinner .. " con el número " .. winningNumber .. "! ¡Mucha suerte para la próxima!")
        else
            SendWorldMessage("¡No hubo ganador de la lotería en este día! El número en sorteo era " .. winningNumber .. ". ¡Mucha suerte para la próxima!")
        end
        IniciarLoteria()
        startTime = os.time()
    end
end
CreateLuaEvent(CheckTime, 60 * 1000, 0) -- Verificar cada minuto
