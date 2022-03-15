RegisterServerEvent('ebu:updateTrailer')
AddEventHandler('ebu:updateTrailer', function(type, num, vehicle, status)
    TriggerClientEvent('ebu:updateTrailer', -1, type, num, vehicle, status)
end)