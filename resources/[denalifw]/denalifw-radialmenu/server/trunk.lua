local DenaliFW = exports['denalifw-core']:GetCoreObject()
local trunkBusy = {}

RegisterNetEvent('denalifw-radialmenu:trunk:server:Door', function(open, plate, door)
    TriggerClientEvent('denalifw-radialmenu:trunk:client:Door', -1, plate, door, open)
end)

RegisterNetEvent('denalifw-trunk:server:setTrunkBusy', function(plate, busy)
    trunkBusy[plate] = busy
end)

RegisterNetEvent('denalifw-trunk:server:KidnapTrunk', function(targetId, closestVehicle)
    TriggerClientEvent('denalifw-trunk:client:KidnapGetIn', targetId, closestVehicle)
end)

DenaliFW.Functions.CreateCallback('denalifw-trunk:server:getTrunkBusy', function(source, cb, plate)
    if trunkBusy[plate] then cb(true) return end
    cb(false)
end)

DenaliFW.Commands.Add("getintrunk", Lang:t("general.getintrunk_command_desc"), {}, false, function(source)
    TriggerClientEvent('denalifw-trunk:client:GetIn', source)
end)

DenaliFW.Commands.Add("putintrunk", Lang:t("general.putintrunk_command_desc"), {}, false, function(source)
    TriggerClientEvent('denalifw-trunk:server:KidnapTrunk', source)
end)