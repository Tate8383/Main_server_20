local DenaliFW = exports['denalifw-core']:GetCoreObject()
local ResetStress = false

DenaliFW.Commands.Add('cash', 'Check Cash Balance', {}, false, function(source, args)
    local Player = DenaliFW.Functions.GetPlayer(source)
    local cashamount = Player.PlayerData.money.cash
    TriggerClientEvent('hud:client:ShowAccounts', source, 'cash', cashamount)
end)

DenaliFW.Commands.Add('bank', 'Check Bank Balance', {}, false, function(source, args)
    local Player = DenaliFW.Functions.GetPlayer(source)
    local bankamount = Player.PlayerData.money.bank
    TriggerClientEvent('hud:client:ShowAccounts', source, 'bank', bankamount)
end)

DenaliFW.Commands.Add("dev", "Enable/Disable developer Mode", {}, false, function(source, args)
    TriggerClientEvent("denalifw-admin:client:ToggleDevmode", source)
end, 'admin')

RegisterNetEvent('hud:server:GainStress', function(amount)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    local newStress
    if not Player or (Config.DisablePoliceStress and Player.PlayerData.job.name == 'police') then return end
    if not ResetStress then
        if not Player.PlayerData.metadata['stress'] then
            Player.PlayerData.metadata['stress'] = 0
        end
        newStress = Player.PlayerData.metadata['stress'] + amount
        if newStress <= 0 then newStress = 0 end
    else
        newStress = 0
    end
    if newStress > 100 then
        newStress = 100
    end
    Player.Functions.SetMetaData('stress', newStress)
    TriggerClientEvent('hud:client:UpdateStress', src, newStress)
    TriggerClientEvent('DenaliFW:Notify', src, Lang:t("notify.stress_gain"), 'error', 1500)
end)

RegisterNetEvent('hud:server:RelieveStress', function(amount)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    local newStress
    if not Player then return end
    if not ResetStress then
        if not Player.PlayerData.metadata['stress'] then
            Player.PlayerData.metadata['stress'] = 0
        end
        newStress = Player.PlayerData.metadata['stress'] - amount
        if newStress <= 0 then newStress = 0 end
    else
        newStress = 0
    end
    if newStress > 100 then
        newStress = 100
    end
    Player.Functions.SetMetaData('stress', newStress)
    TriggerClientEvent('hud:client:UpdateStress', src, newStress)
    TriggerClientEvent('DenaliFW:Notify', src, Lang:t("notify.stress_removed"))
end)

DenaliFW.Functions.CreateCallback('hud:server:HasHarness', function(source, cb)
    local Ply = DenaliFW.Functions.GetPlayer(source)
    local Harness = Ply.Functions.GetItemByName("harness")
    if Harness ~= nil then
        cb(true)
    else
        cb(false)
    end
end)
DenaliFW.Functions.CreateCallback('hud:server:getMenu', function(source, cb)
    cb(Config.Menu)
end) 
