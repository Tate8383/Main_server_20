local DenaliFW = exports['denalifw-core']:GetCoreObject()

DenaliFW.Functions.CreateCallback('denalifw-scoreboard:server:GetCurrentPlayers', function(source, cb)
    local TotalPlayers = 0
    for k, v in pairs(DenaliFW.Functions.GetPlayers()) do
        TotalPlayers = TotalPlayers + 1
    end
    cb(TotalPlayers)
end)

DenaliFW.Functions.CreateCallback('denalifw-scoreboard:server:GetActivity', function(source, cb)
    local PoliceCount = 0
    local AmbulanceCount = 0
    for k, v in pairs(DenaliFW.Functions.GetQBPlayers()) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            PoliceCount = PoliceCount + 1
        end

        if v.PlayerData.job.name == "ambulance" and v.PlayerData.job.onduty then
            AmbulanceCount = AmbulanceCount + 1
        end
    end
    cb(PoliceCount, AmbulanceCount)
end)

DenaliFW.Functions.CreateCallback('denalifw-scoreboard:server:GetConfig', function(source, cb)
    cb(Config.IllegalActions)
end)

DenaliFW.Functions.CreateCallback('denalifw-scoreboard:server:GetPlayersArrays', function(source, cb)
    local players = {}
    for k, v in pairs(DenaliFW.Functions.GetQBPlayers()) do
        players[v.PlayerData.source] = {}
        players[v.PlayerData.source].permission = DenaliFW.Functions.IsOptin(v.PlayerData.source)
    end
    cb(players)
end)

RegisterNetEvent('denalifw-scoreboard:server:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('denalifw-scoreboard:client:SetActivityBusy', -1, activity, bool)
end)