local NADRP = exports['NADRP-core']:GetCoreObject()
local PaymentTax = 15
local Bail = {}

RegisterNetEvent('NADRP-trucker:server:DoBail', function(bool, vehInfo)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)

    if bool then
        if Player.PlayerData.money.cash >= Config.BailPrice then
            Bail[Player.PlayerData.citizenid] = Config.BailPrice
            Player.Functions.RemoveMoney('cash', Config.BailPrice, "tow-received-bail")
            TriggerClientEvent('NADRP:Notify', src, '$250 Deposit Paid With Cash', 'success')
            TriggerClientEvent('NADRP-trucker:client:SpawnVehicle', src, vehInfo)
        elseif Player.PlayerData.money.bank >= Config.BailPrice then
            Bail[Player.PlayerData.citizenid] = Config.BailPrice
            Player.Functions.RemoveMoney('bank', Config.BailPrice, "tow-received-bail")
            TriggerClientEvent('NADRP:Notify', src, '$250 Deposit Paid From Bank', 'success')
            TriggerClientEvent('NADRP-trucker:client:SpawnVehicle', src, vehInfo)
        else
            TriggerClientEvent('NADRP:Notify', src, '$250 Deposit Required', 'error')
        end
    else
        if Bail[Player.PlayerData.citizenid] ~= nil then
            Player.Functions.AddMoney('cash', Bail[Player.PlayerData.citizenid], "trucker-bail-paid")
            Bail[Player.PlayerData.citizenid] = nil
            TriggerClientEvent('NADRP:Notify', src, '$250 Deposit Refunded To Cash', 'success')
        end
    end
end)

RegisterNetEvent('NADRP-trucker:server:01101110', function(drops)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
    local drops = tonumber(drops)
    local bonus = 0
    local DropPrice = math.random(100, 120)

    if drops >= 5 then
        bonus = math.ceil((DropPrice / 10) * 5) + 100
    elseif drops >= 10 then
        bonus = math.ceil((DropPrice / 10) * 7) + 300
    elseif drops >= 15 then
        bonus = math.ceil((DropPrice / 10) * 10) + 400
    elseif drops >= 20 then
        bonus = math.ceil((DropPrice / 10) * 12) + 500
    end

    local price = (DropPrice * drops) + bonus
    local taxAmount = math.ceil((price / 100) * PaymentTax)
    local payment = price - taxAmount
    Player.Functions.AddJobReputation(drops)
    Player.Functions.AddMoney("bank", payment, "trucker-salary")
    TriggerClientEvent('NADRP:Notify', src, 'You Earned $'..payment, 'success')
end)

RegisterNetEvent('NADRP-trucker:server:nano', function()
    local xPlayer = NADRP.Functions.GetPlayer(tonumber(source))
	xPlayer.Functions.AddItem("cryptostick", 1, false)
	TriggerClientEvent('inventory:client:ItemBox', source, NADRP.Shared.Items["cryptostick"], "add")
end)
