local firstConnect = true
AddEventHandler("playerSpawn", function(spawn)
    if firstConnect then
        -- Do stuff to player who's just connected.. This is their "first" time spawning
       firstConnect = false
    end
end)