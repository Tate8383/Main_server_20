local DenaliFW = exports['denalifw-core']:GetCoreObject()
local ItemList = {
    ["casinochips"] = 1,
}

RegisterNetEvent('denalifw-casino:server:sell', function()
    local src = source
    local price = 0
    local Player = DenaliFW.Functions.GetPlayer(src)
    local xItem = Player.Functions.GetItemByName("casinochips")
    if xItem ~= nil then
        for k, v in pairs(Player.PlayerData.items) do
            if Player.PlayerData.items[k] ~= nil then
                if ItemList[Player.PlayerData.items[k].name] ~= nil then
                    price = ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)

        Player.Functions.AddMoney("cash", price, "sold-casino-chips")
            TriggerClientEvent('DenaliFW:Notify', src, "You sold your chips for $"..price)
            TriggerEvent("denalifw-log:server:CreateLog", "casino", "Chips", "blue", "**"..GetPlayerName(src) .. "** got $"..price.." for selling the Chips")
                end
            end
        end
    else
        TriggerClientEvent('DenaliFW:Notify', src, "You have no chips..")
    end
end)

function SetExports()
exports["denalifw-blackjack"]:SetGetChipsCallback(function(source)
    local Player = DenaliFW.Functions.GetPlayer(source)
    local Chips = Player.Functions.GetItemByName("casinochips")

    if Chips ~= nil then
        Chips = Chips
    end

    return TriggerClientEvent('DenaliFW:Notify', src, "You have no chips..")
end)

    exports["denalifw-blackjack"]:SetTakeChipsCallback(function(source, amount)
        local Player = DenaliFW.Functions.GetPlayer(source)

        if Player ~= nil then
            Player.Functions.RemoveItem("casinochips", amount)
            TriggerClientEvent('inventory:client:ItemBox', source, DenaliFW.Shared.Items['casinochips'], "remove")
            TriggerEvent("denalifw-log:server:CreateLog", "casino", "Chips", "yellow", "**"..GetPlayerName(source) .. "** put $"..amount.." in table")
        end
    end)

    exports["denalifw-blackjack"]:SetGiveChipsCallback(function(source, amount)
        local Player = DenaliFW.Functions.GetPlayer(source)

        if Player ~= nil then
            Player.Functions.AddItem("casinochips", amount)
            TriggerClientEvent('inventory:client:ItemBox', source, DenaliFW.Shared.Items['casinochips'], "add")
            TriggerEvent("denalifw-log:server:CreateLog", "casino", "Chips", "red", "**"..GetPlayerName(source) .. "** got $"..amount.." from table table and he won the double")
        end
    end)
end

AddEventHandler("onResourceStart", function(resourceName)
	if ("denalifw-blackjack" == resourceName) then
        Citizen.Wait(1000)
        SetExports()
    end
end)

SetExports()
