local NADRP = exports['NADRP-core']:GetCoreObject()
local tunedVehicles = {}
local VehicleNitrous = {}

NADRP.Functions.CreateUseableItem("tunerlaptop", function(source, item)
    TriggerClientEvent('NADRP-tunerchip:client:openChip', source)
end)

RegisterNetEvent('NADRP-tunerchip:server:TuneStatus', function(plate, bool)
    if bool then
        tunedVehicles[plate] = bool
    else
        tunedVehicles[plate] = nil
    end
end)

NADRP.Functions.CreateCallback('NADRP-tunerchip:server:HasChip', function(source, cb)
    local src = source
    local Ply = NADRP.Functions.GetPlayer(src)
    local Chip = Ply.Functions.GetItemByName('tunerlaptop')

    if Chip ~= nil then
        cb(true)
    else
        DropPlayer(src, 'This is not the idea, is it?')
        cb(true)
    end
end)

NADRP.Functions.CreateCallback('NADRP-tunerchip:server:GetStatus', function(source, cb, plate)
    cb(tunedVehicles[plate])
end)

NADRP.Functions.CreateUseableItem("nitrous", function(source, item)
    TriggerClientEvent('smallresource:client:LoadNitrous', source)
end)

RegisterNetEvent('nitrous:server:LoadNitrous', function(Plate)
    VehicleNitrous[Plate] = {
        hasnitro = true,
        level = 100,
    }
    TriggerClientEvent('nitrous:client:LoadNitrous', -1, Plate)
end)

RegisterNetEvent('nitrous:server:SyncFlames', function(netId)
    TriggerClientEvent('nitrous:client:SyncFlames', -1, netId, source)
end)

RegisterNetEvent('nitrous:server:UnloadNitrous', function(Plate)
    VehicleNitrous[Plate] = nil
    TriggerClientEvent('nitrous:client:UnloadNitrous', -1, Plate)
end)

RegisterNetEvent('nitrous:server:UpdateNitroLevel', function(Plate, level)
    VehicleNitrous[Plate].level = level
    TriggerClientEvent('nitrous:client:UpdateNitroLevel', -1, Plate, level)
end)

RegisterNetEvent('nitrous:server:StopSync', function(plate)
    TriggerClientEvent('nitrous:client:StopSync', -1, plate)
end)
