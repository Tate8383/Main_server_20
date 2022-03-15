local NADRP = exports['NADRP-core']:GetCoreObject()
local trunkBusy = {}

RegisterNetEvent('NADRP-radialmenu:trunk:server:Door', function(open, plate, door)
    TriggerClientEvent('NADRP-radialmenu:trunk:client:Door', -1, plate, door, open)
end)

RegisterNetEvent('NADRP-trunk:server:setTrunkBusy', function(plate, busy)
    trunkBusy[plate] = busy
end)

RegisterNetEvent('NADRP-trunk:server:KidnapTrunk', function(targetId, closestVehicle)
    TriggerClientEvent('NADRP-trunk:client:KidnapGetIn', targetId, closestVehicle)
end)

NADRP.Functions.CreateCallback('NADRP-trunk:server:getTrunkBusy', function(source, cb, plate)
    if trunkBusy[plate] then cb(true) return end
    cb(false)
end)

NADRP.Commands.Add("getintrunk", Lang:t("general.getintrunk_command_desc"), {}, false, function(source)
    TriggerClientEvent('NADRP-trunk:client:GetIn', source)
end)

NADRP.Commands.Add("putintrunk", Lang:t("general.putintrunk_command_desc"), {}, false, function(source)
    TriggerClientEvent('NADRP-trunk:server:KidnapTrunk', source)
end)