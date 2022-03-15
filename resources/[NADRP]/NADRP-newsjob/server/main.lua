local NADRP = exports['NADRP-core']:GetCoreObject()

NADRP.Commands.Add("newscam", "Grab a news camera", {}, false, function(source, args)
    local Player = NADRP.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Cam:ToggleCam", source)
    end
end)

NADRP.Commands.Add("newsmic", "Grab a news microphone", {}, false, function(source, args)
    local Player = NADRP.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Mic:ToggleMic", source)
    end
end)

NADRP.Commands.Add("newsbmic", "Grab a Boom microphone", {}, false, function(source, args)
    local Player = NADRP.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Mic:ToggleBMic", source)
    end
end)
