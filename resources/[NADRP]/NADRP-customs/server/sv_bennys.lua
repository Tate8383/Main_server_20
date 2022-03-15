local NADRP = exports['NADRP-core']:GetCoreObject()

local repairCost = vehicleBaseRepairCost

RegisterNetEvent('NADRP-customs:attemptPurchase', function(type, upgradeLevel)
    local source = source
    local Player = NADRP.Functions.GetPlayer(source)
    local balance = nil
    if Player.PlayerData.job.name == "mechanic" then
        balance = exports['NADRP-bossmenu']:GetAccount(Player.PlayerData.job.name)
    else
        balance = Player.Functions.GetMoney(moneyType)
    end
    if type == "repair" then
        if balance >= repairCost then
            if Player.PlayerData.job.name == "mechanic" then
                TriggerEvent('NADRP-bossmenu:server:removeAccountMoney', Player.PlayerData.job.name, repairCost)
            else
                Player.Functions.RemoveMoney(moneyType, repairCost, "bennys")
            end
            TriggerClientEvent('NADRP-customs:purchaseSuccessful', source)
        else
            TriggerClientEvent('NADRP-customs:purchaseFailed', source)
        end
    elseif type == "performance" then
        if balance >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('NADRP-customs:purchaseSuccessful', source)
            if Player.PlayerData.job.name == "mechanic" then
                TriggerEvent('NADRP-bossmenu:server:removeAccountMoney', Player.PlayerData.job.name,
                    vehicleCustomisationPrices[type].prices[upgradeLevel])
            else
                Player.Functions.RemoveMoney(moneyType, vehicleCustomisationPrices[type].prices[upgradeLevel], "bennys")
            end
        else
            TriggerClientEvent('NADRP-customs:purchaseFailed', source)
        end
    else
        if balance >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('NADRP-customs:purchaseSuccessful', source)
            if Player.PlayerData.job.name == "mechanic" then
                TriggerEvent('NADRP-bossmenu:server:removeAccountMoney', Player.PlayerData.job.name,
                    vehicleCustomisationPrices[type].price)
            else
                Player.Functions.RemoveMoney(moneyType, vehicleCustomisationPrices[type].price, "bennys")
            end
        else
            TriggerClientEvent('NADRP-customs:purchaseFailed', source)
        end
    end
end)

RegisterNetEvent('NADRP-customs:updateRepairCost', function(cost)
    repairCost = cost
end)

RegisterNetEvent("updateVehicle", function(myCar)
    local src = source
    if IsVehicleOwned(myCar.plate) then
        MySQL.Async.execute('UPDATE player_vehicles SET mods = ? WHERE plate = ?', {json.encode(myCar), myCar.plate})
    end
end)

function IsVehicleOwned(plate)
    local retval = false
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        retval = true
    end
    return retval
end
