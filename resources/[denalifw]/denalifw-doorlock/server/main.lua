RegisterNetEvent('denalifw-doorlock:server:setupDoors', function()
	TriggerClientEvent("denalifw-doorlock:client:setDoors", QB.Doors)
end)

RegisterNetEvent('denalifw-doorlock:server:updateState', function(doorID, state)
	QB.Doors[doorID].locked = state
	TriggerClientEvent('denalifw-doorlock:client:setState', -1, doorID, state)
end)