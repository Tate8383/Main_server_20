-- Variables

local NADRP = exports['NADRP-core']:GetCoreObject()
local certificateAmount = 43

-- Events

RegisterNetEvent('NADRP-ifruitstore:server:LoadLocationList', function()
    local src = source
    TriggerClientEvent("NADRP-ifruitstore:server:LoadLocationList", src, Config.Locations)
end)

RegisterNetEvent('NADRP-ifruitstore:server:setSpotState', function(stateType, state, spot)
    if stateType == "isBusy" then
        Config.Locations["takeables"][spot].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["takeables"][spot].isDone = state
    end
    TriggerClientEvent('NADRP-ifruitstore:client:setSpotState', -1, stateType, state, spot)
end)

RegisterNetEvent('NADRP-ifruitstore:server:SetThermiteStatus', function(stateType, state)
    if stateType == "isBusy" then
        Config.Locations["thermite"].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["thermite"].isDone = state
    end
    TriggerClientEvent('NADRP-ifruitstore:client:SetThermiteStatus', -1, stateType, state)
end)

RegisterNetEvent('NADRP-ifruitstore:server:SafeReward', function()
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', math.random(1500, 2000), "robbery-ifruit")
    Player.Functions.AddItem("certificate", certificateAmount)
    TriggerClientEvent('inventory:client:ItemBox', src, NADRP.Shared.Items["certificate"], "add")
    Wait(500)
    local luck = math.random(1, 100)
    if luck <= 10 then
        Player.Functions.AddItem("goldbar", math.random(1, 2))
        TriggerClientEvent('inventory:client:ItemBox', src, NADRP.Shared.Items["goldbar"], "add")
    end
end)

RegisterNetEvent('NADRP-ifruitstore:server:SetSafeStatus', function(stateType, state)
    if stateType == "isBusy" then
        Config.Locations["safe"].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["safe"].isDone = state
    end
    TriggerClientEvent('NADRP-ifruitstore:client:SetSafeStatus', -1, stateType, state)
end)

RegisterNetEvent('NADRP-ifruitstore:server:itemReward', function(spot)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
    local item = Config.Locations["takeables"][spot].reward

    if Player.Functions.AddItem(item.name, item.amount) then
        TriggerClientEvent('inventory:client:ItemBox', src, NADRP.Shared.Items[item.name], 'add')
    else
        TriggerClientEvent('NADRP:Notify', src, 'You have to much in your pocket ..', 'error')
    end
end)

RegisterNetEvent('NADRP-ifruitstore:server:PoliceAlertMessage', function(msg, coords, blip)
    for k, v in pairs(NADRP.Functions.GetPlayers()) do
        local Player = NADRP.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police") then
                TriggerClientEvent("NADRP-ifruitstore:client:PoliceAlertMessage", v, msg, coords, blip)
            end
        end
    end
end)

RegisterNetEvent('NADRP-ifruitstore:server:callCops', function(streetLabel, coords)
    TriggerClientEvent("NADRP-ifruitstore:client:robberyCall", -1, streetLabel, coords)
end)
