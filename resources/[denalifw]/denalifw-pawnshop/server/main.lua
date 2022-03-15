local DenaliFW = exports['denalifw-core']:GetCoreObject()

RegisterNetEvent("denalifw-pawnshop:server:sellPawnItems", function(itemName, itemAmount, itemPrice)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    local totalPrice = (tonumber(itemAmount) * itemPrice)

    if Player.Functions.RemoveItem(itemName, tonumber(itemAmount)) then
        if Config.BankMoney then
            Player.Functions.AddMoney("bank", totalPrice)
        else
            Player.Functions.AddMoney("cash", totalPrice)
        end

        TriggerClientEvent("DenaliFW:Notify", src, Lang:t('success.sold', {value = tonumber(itemAmount), value2 = DenaliFW.Shared.Items[itemName].label, value3 = totalPrice}), 'success')
        TriggerClientEvent('inventory:client:ItemBox', src, DenaliFW.Shared.Items[itemName], 'remove')
    else
        TriggerClientEvent("DenaliFW:Notify", src, Lang:t('error.no_items'), "error")
    end
end)

RegisterNetEvent("denalifw-pawnshop:server:meltItemRemove", function(itemName, itemAmount,item)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    local meltTime = 0

    if Player.Functions.RemoveItem(itemName, itemAmount) then
        TriggerClientEvent('inventory:client:ItemBox', src, DenaliFW.Shared.Items[itemName], 'remove')
        
        meltTime = (tonumber(itemAmount) * item.time)
        TriggerClientEvent('denalifw-pawnshop:client:startMelting', src, item, tonumber(itemAmount), (meltTime* 60000/1000))

        TriggerClientEvent("DenaliFW:Notify", src, Lang:t('info.melt_wait', {value = meltTime}), "primary")
    else
        TriggerClientEvent("DenaliFW:Notify", src, Lang:t('error.no_items'), "error")
    end
end)

RegisterNetEvent("denalifw-pawnshop:server:pickupMelted", function(item)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    local meltedAmount = 0
    local rewardAmount = 0

    for k,v in pairs(item.items) do
        meltedAmount = v.amount
        for l,m in pairs(v.item.reward) do
            rewardAmount = m.amount
            Player.Functions.AddItem(m.item, (meltedAmount * rewardAmount))
            TriggerClientEvent('inventory:client:ItemBox', src, DenaliFW.Shared.Items[m.item], 'add')
            TriggerClientEvent('DenaliFW:Notify', src, Lang:t('success.items_received', {value = (meltedAmount * rewardAmount), value2 = DenaliFW.Shared.Items[m.item].label}), 'success')
        end
    end

    TriggerClientEvent('denalifw-pawnshop:client:resetPickup', src)
end)

DenaliFW.Functions.CreateCallback('denalifw-pawnshop:server:getInv', function(source, cb)
    local Player = DenaliFW.Functions.GetPlayer(source)
    local inventory = Player.PlayerData.items

    return cb(inventory)
end)