local DenaliFW = exports['denalifw-core']:GetCoreObject()
DenaliFW.Commands.Add("fix", "Repair your vehicle (Admin Only)", {}, false, function(source)
    TriggerClientEvent('iens:repaira', source)
    TriggerClientEvent('vehiclemod:client:fixEverything', source)
end, "admin")

DenaliFW.Functions.CreateUseableItem("repairkit", function(source, item)
    local Player = DenaliFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("denalifw-vehiclefailure:client:RepairVehicle", source)
    end
end)

DenaliFW.Functions.CreateUseableItem("cleaningkit", function(source, item)
    local Player = DenaliFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("denalifw-vehiclefailure:client:CleanVehicle", source)
    end
end)

DenaliFW.Functions.CreateUseableItem("advancedrepairkit", function(source, item)
    local Player = DenaliFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("denalifw-vehiclefailure:client:RepairVehicleFull", source)
    end
end)

RegisterNetEvent('denalifw-vehiclefailure:removeItem', function(item)
    local src = source
    local ply = DenaliFW.Functions.GetPlayer(src)
    ply.Functions.RemoveItem(item, 1)
end)

RegisterNetEvent('denalifw-vehiclefailure:server:removewashingkit', function(veh)
    local src = source
    local ply = DenaliFW.Functions.GetPlayer(src)
    ply.Functions.RemoveItem("cleaningkit", 1)
    TriggerClientEvent('denalifw-vehiclefailure:client:SyncWash', -1, veh)
end)