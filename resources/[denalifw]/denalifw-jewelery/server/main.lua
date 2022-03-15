local DenaliFW = exports['denalifw-core']:GetCoreObject()
local timeOut = false

-- Callback

DenaliFW.Functions.CreateCallback('denalifw-jewellery:server:getCops', function(source, cb)
	local amount = 0
    for k, v in pairs(DenaliFW.Functions.GetQBPlayers()) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    cb(amount)
end)

-- Events

RegisterNetEvent('denalifw-jewellery:server:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
    TriggerClientEvent('denalifw-jewellery:client:setVitrineState', -1, stateType, state, k)
end)

RegisterNetEvent('denalifw-jewellery:server:vitrineReward', function()
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    local otherchance = math.random(1, 4)
    local odd = math.random(1, 4)

    if otherchance == odd then
        local item = math.random(1, #Config.VitrineRewards)
        local amount = math.random(Config.VitrineRewards[item]["amount"]["min"], Config.VitrineRewards[item]["amount"]["max"])
        if Player.Functions.AddItem(Config.VitrineRewards[item]["item"], amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, DenaliFW.Shared.Items[Config.VitrineRewards[item]["item"]], 'add')
        else
            TriggerClientEvent('DenaliFW:Notify', src, 'You have to much in your pocket', 'error')
        end
    else
        local amount = math.random(2, 4)
        if Player.Functions.AddItem("10kgoldchain", amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, DenaliFW.Shared.Items["10kgoldchain"], 'add')
        else
            TriggerClientEvent('DenaliFW:Notify', src, 'You have to much in your pocket..', 'error')
        end
    end
end)

RegisterNetEvent('denalifw-jewellery:server:setTimeout', function()
    if not timeOut then
        timeOut = true
        TriggerEvent('denalifw-scoreboard:server:SetActivityBusy', "jewellery", true)
        Citizen.CreateThread(function()
            Citizen.Wait(Config.Timeout)

            for k, v in pairs(Config.Locations) do
                Config.Locations[k]["isOpened"] = false
                TriggerClientEvent('denalifw-jewellery:client:setVitrineState', -1, 'isOpened', false, k)
                TriggerClientEvent('denalifw-jewellery:client:setAlertState', -1, false)
                TriggerEvent('denalifw-scoreboard:server:SetActivityBusy', "jewellery", false)
            end
            timeOut = false
        end)
    end
end)