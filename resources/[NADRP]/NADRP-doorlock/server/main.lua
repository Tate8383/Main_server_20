RegisterNetEvent('NADRP-doorlock:server:setupDoors', function()
	TriggerClientEvent("NADRP-doorlock:client:setDoors", QB.Doors)
end)

RegisterNetEvent('NADRP-doorlock:server:updateState', function(doorID, state)
	QB.Doors[doorID].locked = state
	TriggerClientEvent('NADRP-doorlock:client:setState', -1, doorID, state)
end)