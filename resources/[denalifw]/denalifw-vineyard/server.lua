local DenaliFW = exports['denalifw-core']:GetCoreObject()

RegisterNetEvent('denalifw-vineyard:server:getGrapes', function()
    local Player = DenaliFW.Functions.GetPlayer(source)
    Player.Functions.AddItem("grape", Config.GrapeAmount)
    TriggerClientEvent('inventory:client:ItemBox', source, DenaliFW.Shared.Items['grape'], "add")
end)

RegisterNetEvent('denalifw-vineyard:server:loadIngredients', function()
	local xPlayer = DenaliFW.Functions.GetPlayer(tonumber(source))
    local grape = xPlayer.Functions.GetItemByName('grapejuice')
	if xPlayer.PlayerData.items ~= nil then
        if grape ~= nil then
            if grape.amount >= 23 then
                xPlayer.Functions.RemoveItem("grapejuice", 23, false)
                TriggerClientEvent('inventory:client:ItemBox', source, DenaliFW.Shared.Items['grapejuice'], "remove")
                TriggerClientEvent("denalifw-vineyard:client:loadIngredients", source)
            else
                TriggerClientEvent('DenaliFW:Notify', source, Lang:t("error.invalid_items"), 'error')
            end
        else
            TriggerClientEvent('DenaliFW:Notify', source, Lang:t("error.invalid_items"), 'error')
        end
	else
		TriggerClientEvent('DenaliFW:Notify', source, Lang:t("error.no_items"), "error")
	end
end)

RegisterNetEvent('denalifw-vineyard:server:grapeJuice', function()
	local xPlayer = DenaliFW.Functions.GetPlayer(tonumber(source))
    local grape = xPlayer.Functions.GetItemByName('grape')
	if xPlayer.PlayerData.items ~= nil then
        if grape ~= nil then
            if grape.amount >= 16 then
                xPlayer.Functions.RemoveItem("grape", 16, false)
                TriggerClientEvent('inventory:client:ItemBox', source, DenaliFW.Shared.Items['grape'], "remove")
                TriggerClientEvent("denalifw-vineyard:client:grapeJuice", source)
            else
                TriggerClientEvent('DenaliFW:Notify', source, Lang:t("error.invalid_items"), 'error')
            end
        else
            TriggerClientEvent('DenaliFW:Notify', source, Lang:t("error.invalid_items"), 'error')
        end
	else
		TriggerClientEvent('DenaliFW:Notify', source, Lang:t("error.no_items"), "error")
	end
end)

RegisterNetEvent('denalifw-vineyard:server:receiveWine', function()
	local xPlayer = DenaliFW.Functions.GetPlayer(tonumber(source))
	xPlayer.Functions.AddItem("wine", Config.WineAmount, false)
	TriggerClientEvent('inventory:client:ItemBox', source, DenaliFW.Shared.Items['wine'], "add")
end)

RegisterNetEvent('denalifw-vineyard:server:receiveGrapeJuice', function()
	local xPlayer = DenaliFW.Functions.GetPlayer(tonumber(source))
	xPlayer.Functions.AddItem("grapejuice", Config.GrapeJuiceAmount, false)
	TriggerClientEvent('inventory:client:ItemBox', source, DenaliFW.Shared.Items['grapejuice'], "add")
end)
