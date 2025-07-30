Sistema de Lotería Customizable para AzerothCore (WotLK 3.3.5a)
Script Lua (Eluna) que añade una lotería interactiva con NPC, apuestas con oro, premios personalizables y reinicio automático.

-- Características
NPC de Lotería con diálogo interactivo (Gossip).
Apuestas con oro (configurable).
Premios personalizables: Oro + Tokens + Ítems (monturas, etc.).
Número ganador aleatorio (1-20).
Anuncios globales al ganar o reiniciar.
Límite de 1 apuesta por jugador por ronda.
Reinicio automático cada X tiempo (24h por defecto, editable).

--Configuración
Edita las variables al inicio del script para personalizarlo:

lua
local LOTTERY_NPC_ID = 1111       -- ID del NPC que manejará la lotería.
local BET_COST = 1000000          -- Coste de la apuesta (en cobre: 1.000.000 = 100 de oro).
local WIN_REWARD = 25000000       -- Recompensa en oro al ganar (250 de oro).
local TOKEN_ID = 11111            -- ID del token (Ej: Triunfo/Escarcha).
local TOKEN_AMOUNT = 25           -- Cantidad de tokens al ganar.
local ITEM_REWARD_ID = 43599      -- ID del ítem adicional (Ej: Montura Oso de Blizzard).
local ITEM_REWARD_AMOUNT = 1      -- Cantidad del ítem adicional.
local RESET_INTERVAL = 3600       -- Tiempo de reinicio en segundos (3600 = 1 hora).

--Instalación
Coloca el script en la carpeta lua_scripts de tu servidor AzerothCore.

Asegúrate de que el NPC exista (crea uno con el ID configurado o cambia LOTTERY_NPC_ID).

Reinicia el worldserver o usa .reload eluna para cargar el script.


--Uso en el Juego
Habla con el NPC de la lotería (ID configurado).

Elige un número del 1 al 20 y apuesta.

Si aciertas, recibirás:

Oro (cantidad configurada).

Tokens (Ej: Triunfos/Escarcha).

Ítem adicional (montura, etc.).

El sistema se reinicia automáticamente cada X tiempo (por defecto, 1 hora).

--Mensajes del Sistema
Al iniciar la primera apuesta:
¡Lotería en Servidor! Se ha iniciado la primera apuesta...

Al ganar:
¡Felicidades! Has ganado la lotería con el número X...

Al reiniciar:
¡El jugador ganador ha sido [Nombre] con el número X!

--Personalización Avanzada
Cambia los IDs de los ítems/tokens en las variables.

Ajusta el tiempo de reinicio modificando RESET_INTERVAL.

Añade más premios editando la función HacerApuesta().

