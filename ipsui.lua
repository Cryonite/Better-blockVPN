

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
