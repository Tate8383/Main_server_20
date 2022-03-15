-- Variables

local DenaliFW = exports['denalifw-core']:GetCoreObject()
local certificateAmount = 43

-- Events

RegisterNetEvent('denalifw-ifruitstore:server:LoadLocationList', function()
    local src = source
    TriggerClientEvent("denalifw-ifruitstore:server:LoadLocationList", src, Config.Locations)
end)

RegisterNetEvent('denalifw-ifruitstore:server:setSpotState', function(stateType, state, spot)
    if stateType == "isBusy" then
        Config.Locations["takeables"][spot].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["takeables"][spot].isDone = state
    end
    TriggerClientEvent('denalifw-ifruitstore:client:setSpotState', -1, stateType, state, spot)
end)

RegisterNetEvent('denalifw-ifruitstore:server:SetThermiteStatus', function(stateType, state)
    if stateType == "isBusy" then
        Config.Locations["thermite"].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["thermite"].isDone = state
    end
    TriggerClientEvent('denalifw-ifruitstore:client:SetThermiteStatus', -1, stateType, state)
end)

RegisterNetEvent('denalifw-ifruitstore:server:SafeReward', function()
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', math.random(1500, 2000), "robbery-ifruit")
    Player.Functions.AddItem("certificate", certificateAmount)
    TriggerClientEvent('inventory:client:ItemBox', src, DenaliFW.Shared.Items["certificate"], "add")
    Wait(500)
    local luck = math.random(1, 100)
    if luck <= 10 then
        Player.Functions.AddItem("goldbar", math.random(1, 2))
        TriggerClientEvent('inventory:client:ItemBox', src, DenaliFW.Shared.Items["goldbar"], "add")
    end
end)

RegisterNetEvent('denalifw-ifruitstore:server:SetSafeStatus', function(stateType, state)
    if stateType == "isBusy" then
        Config.Locations["safe"].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["safe"].isDone = state
    end
    TriggerClientEvent('denalifw-ifruitstore:client:SetSafeStatus', -1, stateType, state)
end)

RegisterNetEvent('denalifw-ifruitstore:server:itemReward', function(spot)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    local item = Config.Locations["takeables"][spot].reward

    if Player.Functions.AddItem(item.name, item.amount) then
        TriggerClientEvent('inventory:client:ItemBox', src, DenaliFW.Shared.Items[item.name], 'add')
    else
        TriggerClientEvent('DenaliFW:Notify', src, 'You have to much in your pocket ..', 'error')
    end
end)

RegisterNetEvent('denalifw-ifruitstore:server:PoliceAlertMessage', function(msg, coords, blip)
    for k, v in pairs(DenaliFW.Functions.GetPlayers()) do
        local Player = DenaliFW.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police") then
                TriggerClientEvent("denalifw-ifruitstore:client:PoliceAlertMessage", v, msg, coords, blip)
            end
        end
    end
end)

RegisterNetEvent('denalifw-ifruitstore:server:callCops', function(streetLabel, coords)
    TriggerClientEvent("denalifw-ifruitstore:client:robberyCall", -1, streetLabel, coords)
end)
