local NADRP = exports['NADRP-core']:GetCoreObject()
NADRP.Commands.Add("fix", "Repair your vehicle (Admin Only)", {}, false, function(source)
    TriggerClientEvent('iens:repaira', source)
    TriggerClientEvent('vehiclemod:client:fixEverything', source)
end, "admin")

NADRP.Functions.CreateUseableItem("repairkit", function(source, item)
    local Player = NADRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("NADRP-vehiclefailure:client:RepairVehicle", source)
    end
end)

NADRP.Functions.CreateUseableItem("cleaningkit", function(source, item)
    local Player = NADRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("NADRP-vehiclefailure:client:CleanVehicle", source)
    end
end)

NADRP.Functions.CreateUseableItem("advancedrepairkit", function(source, item)
    local Player = NADRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("NADRP-vehiclefailure:client:RepairVehicleFull", source)
    end
end)

RegisterNetEvent('NADRP-vehiclefailure:removeItem', function(item)
    local src = source
    local ply = NADRP.Functions.GetPlayer(src)
    ply.Functions.RemoveItem(item, 1)
end)

RegisterNetEvent('NADRP-vehiclefailure:server:removewashingkit', function(veh)
    local src = source
    local ply = NADRP.Functions.GetPlayer(src)
    ply.Functions.RemoveItem("cleaningkit", 1)
    TriggerClientEvent('NADRP-vehiclefailure:client:SyncWash', -1, veh)
end)