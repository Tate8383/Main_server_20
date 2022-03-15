RegisterNetEvent('NADRP-radialmenu:server:RemoveStretcher', function(pos, stretcherObject)
    TriggerClientEvent('NADRP-radialmenu:client:RemoveStretcherFromArea', -1, pos, stretcherObject)
end)

RegisterNetEvent('NADRP-radialmenu:Stretcher:BusyCheck', function(id, type)
    TriggerClientEvent('NADRP-radialmenu:Stretcher:client:BusyCheck', id, source, type)
end)

RegisterNetEvent('NADRP-radialmenu:server:BusyResult', function(isBusy, otherId, type)
    TriggerClientEvent('NADRP-radialmenu:client:Result', otherId, isBusy, type)
end)