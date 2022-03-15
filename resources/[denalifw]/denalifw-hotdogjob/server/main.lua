local DenaliFW = exports['denalifw-core']:GetCoreObject()
local Bail = {}

DenaliFW.Functions.CreateCallback('denalifw-hotdogjob:server:HasMoney', function(source, cb)
    local Player = DenaliFW.Functions.GetPlayer(source)

    if Player.PlayerData.money.bank >= Config.Bail then
        Player.Functions.RemoveMoney('bank', Config.Bail)
        Bail[Player.PlayerData.citizenid] = true
        cb(true)
    else
        Bail[Player.PlayerData.citizenid] = false
        cb(false)
    end
end)

DenaliFW.Functions.CreateCallback('denalifw-hotdogjob:server:BringBack', function(source, cb)
    local Player = DenaliFW.Functions.GetPlayer(source)

    if Bail[Player.PlayerData.citizenid] then
        Player.Functions.AddMoney('bank', Config.Bail)
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent('denalifw-hotdogjob:server:Sell', function(Amount, Price)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)

    Player.Functions.AddMoney('cash', tonumber(Amount * Price))
end)

RegisterNetEvent('denalifw-hotdogjob:server:UpdateReputation', function(quality)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    local JobReputation = Player.PlayerData.metadata["jobrep"]

    if quality == "exotic" then
        if JobReputation["hotdog"] ~= nil and JobReputation["hotdog"] + 3 > Config.MaxReputation then
            JobReputation["hotdog"] = Config.MaxReputation
            Player.Functions.SetMetaData("jobrep", JobReputation)
            TriggerClientEvent('denalifw-hotdogjob:client:UpdateReputation', src, JobReputation)
            return
        end
        if JobReputation["hotdog"] == nil then
            JobReputation["hotdog"] = 3
        else
            JobReputation["hotdog"] = JobReputation["hotdog"] + 3
        end
    elseif quality == "rare" then
        if JobReputation["hotdog"] ~= nil and JobReputation["hotdog"] + 2 > Config.MaxReputation then
            JobReputation["hotdog"] = Config.MaxReputation
            Player.Functions.SetMetaData("jobrep", JobReputation)
            TriggerClientEvent('denalifw-hotdogjob:client:UpdateReputation', src, JobReputation)
            return
        end
        if JobReputation["hotdog"] == nil then
            JobReputation["hotdog"] = 2
        else
            JobReputation["hotdog"] = JobReputation["hotdog"] + 2
        end
    elseif quality == "common" then
        if JobReputation["hotdog"] ~= nil and JobReputation["hotdog"] + 1 > Config.MaxReputation then
            JobReputation["hotdog"] = Config.MaxReputation
            Player.Functions.SetMetaData("jobrep", JobReputation)
            TriggerClientEvent('denalifw-hotdogjob:client:UpdateReputation', src, JobReputation)
            return
        end
        if JobReputation["hotdog"] == nil then
            JobReputation["hotdog"] = 1
        else
            JobReputation["hotdog"] = JobReputation["hotdog"] + 1
        end
    end
    Player.Functions.SetMetaData("jobrep", JobReputation)
    TriggerClientEvent('denalifw-hotdogjob:client:UpdateReputation', src, JobReputation)
end)

DenaliFW.Commands.Add("removestand", Lang:t("info.command"), {}, false, function(source, args)
    TriggerClientEvent('denalifw-hotdogjob:staff:DeletStand', source)
end, 'admin')