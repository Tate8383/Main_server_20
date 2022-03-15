local VehicleNitrous = {}

RegisterNetEvent('tackle:server:TacklePlayer', function(playerId)
    TriggerClientEvent("tackle:client:GetTackled", playerId)
end)

DenaliFW.Functions.CreateCallback('nos:GetNosLoadedVehs', function(source, cb)
    cb(VehicleNitrous)
end)

DenaliFW.Commands.Add("id", "Check Your ID #", {}, false, function(source, args)
    local src = source
    TriggerClientEvent('DenaliFW:Notify', src,  "ID: "..src)
end)

DenaliFW.Functions.CreateUseableItem("harness", function(source, item)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    TriggerClientEvent('seatbelt:client:UseHarness', src, item)
end)

RegisterNetEvent('equip:harness', function(item)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    if Player.PlayerData.items[item.slot].info.uses == 1 then
        TriggerClientEvent("inventory:client:ItemBox", src, DenaliFW.Shared.Items['harness'], "remove")
        Player.Functions.RemoveItem('harness', 1)
    else
        Player.PlayerData.items[item.slot].info.uses = Player.PlayerData.items[item.slot].info.uses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RegisterNetEvent('seatbelt:DoHarnessDamage', function(hp, data)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)

    if hp == 0 then
        Player.Functions.RemoveItem('harness', 1, data.slot)
    else
        Player.PlayerData.items[data.slot].info.uses = Player.PlayerData.items[data.slot].info.uses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RegisterNetEvent('denalifw-carwash:server:washCar', function()
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)

    if Player.Functions.RemoveMoney('cash', Config.DefaultPrice, "car-washed") then
        TriggerClientEvent('denalifw-carwash:client:washCar', src)
    elseif Player.Functions.RemoveMoney('bank', Config.DefaultPrice, "car-washed") then
        TriggerClientEvent('denalifw-carwash:client:washCar', src)
    else
        TriggerClientEvent('DenaliFW:Notify', src, 'You dont have enough money..', 'error')
    end
end)

DenaliFW.Functions.CreateCallback('smallresources:server:GetCurrentPlayers', function(source, cb)
    local TotalPlayers = 0
    for k, v in pairs(DenaliFW.Functions.GetPlayers()) do
        TotalPlayers = TotalPlayers + 1
    end
    cb(TotalPlayers)
end)
