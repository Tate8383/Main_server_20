local NADRP = exports['NADRP-core']:GetCoreObject()
local timeOut = false

-- Callback

NADRP.Functions.CreateCallback('NADRP-jewellery:server:getCops', function(source, cb)
	local amount = 0
    for k, v in pairs(NADRP.Functions.GetQBPlayers()) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    cb(amount)
end)

-- Events

RegisterNetEvent('NADRP-jewellery:server:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
    TriggerClientEvent('NADRP-jewellery:client:setVitrineState', -1, stateType, state, k)
end)

RegisterNetEvent('NADRP-jewellery:server:vitrineReward', function()
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
    local otherchance = math.random(1, 4)
    local odd = math.random(1, 4)

    if otherchance == odd then
        local item = math.random(1, #Config.VitrineRewards)
        local amount = math.random(Config.VitrineRewards[item]["amount"]["min"], Config.VitrineRewards[item]["amount"]["max"])
        if Player.Functions.AddItem(Config.VitrineRewards[item]["item"], amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, NADRP.Shared.Items[Config.VitrineRewards[item]["item"]], 'add')
        else
            TriggerClientEvent('NADRP:Notify', src, 'You have to much in your pocket', 'error')
        end
    else
        local amount = math.random(2, 4)
        if Player.Functions.AddItem("10kgoldchain", amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, NADRP.Shared.Items["10kgoldchain"], 'add')
        else
            TriggerClientEvent('NADRP:Notify', src, 'You have to much in your pocket..', 'error')
        end
    end
end)

RegisterNetEvent('NADRP-jewellery:server:setTimeout', function()
    if not timeOut then
        timeOut = true
        TriggerEvent('NADRP-scoreboard:server:SetActivityBusy', "jewellery", true)
        Citizen.CreateThread(function()
            Citizen.Wait(Config.Timeout)

            for k, v in pairs(Config.Locations) do
                Config.Locations[k]["isOpened"] = false
                TriggerClientEvent('NADRP-jewellery:client:setVitrineState', -1, 'isOpened', false, k)
                TriggerClientEvent('NADRP-jewellery:client:setAlertState', -1, false)
                TriggerEvent('NADRP-scoreboard:server:SetActivityBusy', "jewellery", false)
            end
            timeOut = false
        end)
    end
end)