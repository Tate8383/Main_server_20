local NADRP = exports['NADRP-core']:GetCoreObject()
local ItemList = {
    ["casinochips"] = 1,
}

RegisterNetEvent('NADRP-casino:server:sell', function()
    local src = source
    local price = 0
    local Player = NADRP.Functions.GetPlayer(src)
    local xItem = Player.Functions.GetItemByName("casinochips")
    if xItem ~= nil then
        for k, v in pairs(Player.PlayerData.items) do
            if Player.PlayerData.items[k] ~= nil then
                if ItemList[Player.PlayerData.items[k].name] ~= nil then
                    price = ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)

        Player.Functions.AddMoney("cash", price, "sold-casino-chips")
            TriggerClientEvent('NADRP:Notify', src, "You sold your chips for $"..price)
            TriggerEvent("NADRP-log:server:CreateLog", "casino", "Chips", "blue", "**"..GetPlayerName(src) .. "** got $"..price.." for selling the Chips")
                end
            end
        end
    else
        TriggerClientEvent('NADRP:Notify', src, "You have no chips..")
    end
end)

function SetExports()
exports["NADRP-blackjack"]:SetGetChipsCallback(function(source)
    local Player = NADRP.Functions.GetPlayer(source)
    local Chips = Player.Functions.GetItemByName("casinochips")

    if Chips ~= nil then
        Chips = Chips
    end

    return TriggerClientEvent('NADRP:Notify', src, "You have no chips..")
end)

    exports["NADRP-blackjack"]:SetTakeChipsCallback(function(source, amount)
        local Player = NADRP.Functions.GetPlayer(source)

        if Player ~= nil then
            Player.Functions.RemoveItem("casinochips", amount)
            TriggerClientEvent('inventory:client:ItemBox', source, NADRP.Shared.Items['casinochips'], "remove")
            TriggerEvent("NADRP-log:server:CreateLog", "casino", "Chips", "yellow", "**"..GetPlayerName(source) .. "** put $"..amount.." in table")
        end
    end)

    exports["NADRP-blackjack"]:SetGiveChipsCallback(function(source, amount)
        local Player = NADRP.Functions.GetPlayer(source)

        if Player ~= nil then
            Player.Functions.AddItem("casinochips", amount)
            TriggerClientEvent('inventory:client:ItemBox', source, NADRP.Shared.Items['casinochips'], "add")
            TriggerEvent("NADRP-log:server:CreateLog", "casino", "Chips", "red", "**"..GetPlayerName(source) .. "** got $"..amount.." from table table and he won the double")
        end
    end)
end

AddEventHandler("onResourceStart", function(resourceName)
	if ("NADRP-blackjack" == resourceName) then
        Citizen.Wait(1000)
        SetExports()
    end
end)

SetExports()
