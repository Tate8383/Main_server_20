local NADRP = exports['NADRP-core']:GetCoreObject()

NADRP.Functions.CreateCallback('NADRP-scoreboard:server:GetCurrentPlayers', function(source, cb)
    local TotalPlayers = 0
    for k, v in pairs(NADRP.Functions.GetPlayers()) do
        TotalPlayers = TotalPlayers + 1
    end
    cb(TotalPlayers)
end)

NADRP.Functions.CreateCallback('NADRP-scoreboard:server:GetActivity', function(source, cb)
    local PoliceCount = 0
    local AmbulanceCount = 0
    for k, v in pairs(NADRP.Functions.GetQBPlayers()) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            PoliceCount = PoliceCount + 1
        end

        if v.PlayerData.job.name == "ambulance" and v.PlayerData.job.onduty then
            AmbulanceCount = AmbulanceCount + 1
        end
    end
    cb(PoliceCount, AmbulanceCount)
end)

NADRP.Functions.CreateCallback('NADRP-scoreboard:server:GetConfig', function(source, cb)
    cb(Config.IllegalActions)
end)

NADRP.Functions.CreateCallback('NADRP-scoreboard:server:GetPlayersArrays', function(source, cb)
    local players = {}
    for k, v in pairs(NADRP.Functions.GetQBPlayers()) do
        players[v.PlayerData.source] = {}
        players[v.PlayerData.source].permission = NADRP.Functions.IsOptin(v.PlayerData.source)
    end
    cb(players)
end)

RegisterNetEvent('NADRP-scoreboard:server:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('NADRP-scoreboard:client:SetActivityBusy', -1, activity, bool)
end)