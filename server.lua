--------------
--  CONFIG  --
--------------
local ownerEmail = 'email'             -- Owner Email (Required) - No account needed (Used Incase of Issues)
local kickThreshold = 0.99        -- Anything equal to or higher than this value will be kicked. (0.99 Recommended as Lowest)
local kickReason = 'We\'ve detected that you\'re using a VPN or Proxy. If you believe this is a mistake please make a ticket in our discord server: https://discord.gg/fFuQd5rX7g'
local VPN = 'Usage of VPN' -- neger wordt geclapped door vpn met suggy sus saus
local flags = 'm'				  -- Quickest and most accurate check. Checks IP blacklist.
local printFailed = true
local cacheTime = 8 * 3600        -- How long we should keep the IPs cached, to prevent excessive API Requests.


------- DO NOT EDIT BELOW THIS LINE -------

cache = {}
-- {ip = "1.1.1.1", cachedOn = 1615893672, probability = 0.99}

function splitString(inputstr, sep)
	local t= {}; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
	local nowDateTime = " "..os.date("%d/%m/%Y %X") -- .."\nTime: "..os.date("%X")
	if GetNumPlayerIndices() < GetConvarInt('sv_maxclients', 64) then
		deferrals.defer()
		deferrals.update("Checking Player Information. Please Wait.")
		playerIP = GetPlayerEP(source)
		if string.match(playerIP, ":") then
			playerIP = splitString(playerIP, ":")[1]
		end
		if IsPlayerAceAllowed(source, "blockVPN.bypass") then
			deferrals.done()
			return
		else 
			local probability = 0
			for i,entry in pairs(cache) do
				if entry.ip == playerIP then -- check if our IP is cached
					if entry.cachedOn+cacheTime < os.time() then -- is our cache outdated? If so, drop it and get a fresh value.
						table.remove(cache, i)
					else
						probability = entry.probability
						if probability >= kickThreshold then
							deferrals.done(kickReason)
							sendToDiscord2('blockVPN', "\nPlayer: ".. playerName .. " has been blocked from joining\nFor the reason: " .. VPN .. "\nIP: " .. playerIP .. "\nDate: " .. nowDateTime, 15158332)
							if printFailed then
								print('[BlockVPN][BLOCKED] ' .. playerName .. ' has been blocked from joining with a value of ' .. probability)
							end
							return
						else 
							deferrals.done()
							return
						end
					end
				end
			end
			if playerIP == "127.0.0.1" then 
				deferrals.done() -- dont waste one of our free requests for a local IP.
				return
			end

			PerformHttpRequest('http://check.getipintel.net/check.php?ip=' .. playerIP .. '&contact=' .. ownerEmail .. '&flags=' .. flags, function(statusCode, response, headers)
				if response then
					if tonumber(response) == -5 then
						print('[BlockVPN][ERROR] GetIPIntel seems to have blocked the connection with error code 5 (Either incorrect email, blocked email, or blocked IP. Try changing the contact email)')
						probability = -5
					elseif tonumber(response) == -6 then
						print('[BlockVPN][ERROR] A valid contact email is required!')
						probability = -6
					elseif tonumber(response) == -4 then
						print('[BlockVPN][ERROR] Unable to reach database. Most likely being updated.')
						probability = -4
					else
						table.insert(cache, {ip = playerIP, cachedOn = os.time(), probability = tonumber(response)})
						probability = tonumber(response)
					end
				end
				if probability >= kickThreshold then
					deferrals.done(kickReason)
					sendToDiscord2('blockVPN', "\nPlayer: ".. playerName .. " has been blocked from joining\nFor the reason: " .. VPN .. "\nIP: " .. playerIP .. "\nDate: " .. nowDateTime, 15158332)
					if printFailed then
						print('[BlockVPN][BLOCKED] ' .. playerName .. ' has been blocked from joining with a value of ' .. probability)
					end
				else 
					deferrals.done()
				end
			end)
		end
	end
end)

function sendToDiscord2 (name,message,color)
    local DiscordWebHook = "YOURWEBHOOK"
    -- Modify here your discordWebHook username = name, content = message,embeds = embeds

  local embeds = {
      {
          ["title"]=message,
          ["type"]="rich",
          ["color"] =color,
		  ['description'] = '**EU time** = time + 2 hours\n**Example:** *13:51:37 so the real time is: 15:51:37*',
          ["footer"]=  {
          ["text"]= "ip logged in ips.log in script blockVPN",
         },
      }
  }

    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
  end
