-- dit is een eigen knutseltje van mijzelf
-- In het kort dit logged iedereen zn steamnaam op zn ip adress in het bestandje: ips.log
-- dit is gewoon een klein checkje om zo evt misverstanden kunnen identificeren

-- local function OnPlayerConnecting(name, setKickReason, deferrals)
--   local player = source
--   local steamIdentifier
--   local neger
--   local identifiers = GetPlayerIdentifiers(player)
--   deferrals.defer()

--   -- mandatory wait!
--   Wait(0)

--   deferrals.update(string.format("Hello %s. Your Steam ID is being checked.", name))

--   for _, v, f in pairs(identifiers) do
--       if string.find(v, "steam", f, "neger") then
--           steamIdentifier = v
--           neger = f
--           break
--       end
--   end

--   -- mandatory wait!
--   Wait(0)

--   if not steamIdentifier then
--       deferrals.done("You are not connected to Steam.")
--   elseif not neger then
--       deferrals.done('Jij bent een neger')
--   else
--       deferrals.done()
--   end
-- end

AddEventHandler("playerConnecting", OnPlayerConnecting)

AddEventHandler("playerConnecting", function()
    local nowDateTime = " "..os.date("%d/%m/%Y %X") -- .."\nTime: "..os.date("%X")
    local file = LoadResourceFile(GetCurrentResourceName(), "ips.log")
    sendToDiscord('IPlog', "\nPlayer: " .. GetPlayerName(source) .. "\nIdentifier: " .. GetPlayerIdentifier(source) .. "\nIP: " .. GetPlayerEndpoint(source) .. "\nDate: " .. nowDateTime, 3066993)
    SaveResourceFile(GetCurrentResourceName(), "ips.log", tostring(file) .. tostring(GetPlayerName(source)) .. " | " .. tostring(GetPlayerIdentifier(source)) .. " | " .. tostring(GetPlayerEndpoint(source)) .. " | " .. os.date('%d/%m/%Y %X'), -1)
    print('Information saved of player ' .. GetPlayerName(source))
end)

-- discord
function sendToDiscord (name,message,color)
    local DiscordWebHook = "YOURWEBHOOK"
    -- Modify here your discordWebHook username = name, content = message,embeds = embeds

  local embeds = {
      {
          ["title"]=message,
          ["type"]="rich",
          ["color"] =color,
          ['description'] = '**EU time** = time + 2 hours\n**Example:** *13:51:37 so the real time is: 15:51:37*',
          ["footer"]=  {
          ["text"]= "saved to ips.log in script blockVPN!",
         },
      }
  }

    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name, avatar_url = 'https://i.imgur.com/zCMChCx.png',embeds = embeds,}), { ['Content-Type'] = 'application/json' })
  end