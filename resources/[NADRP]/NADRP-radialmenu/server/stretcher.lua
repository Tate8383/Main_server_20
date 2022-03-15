RegisterNetEvent('denalifw-radialmenu:server:RemoveStretcher', function(pos, stretcherObject)
    TriggerClientEvent('denalifw-radialmenu:client:RemoveStretcherFromArea', -1, pos, stretcherObject)
end)

RegisterNetEvent('denalifw-radialmenu:Stretcher:BusyCheck', function(id, type)
    TriggerClientEvent('denalifw-radialmenu:Stretcher:client:BusyCheck', id, source, type)
end)

RegisterNetEvent('denalifw-radialmenu:server:BusyResult', function(isBusy, otherId, type)
    TriggerClientEvent('denalifw-radialmenu:client:Result', otherId, isBusy, type)
end)