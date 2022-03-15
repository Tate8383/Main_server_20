local NADRP = exports['NADRP-core']:GetCoreObject()

RegisterNetEvent('NADRP-vineyard:server:getGrapes', function()
    local Player = NADRP.Functions.GetPlayer(source)
    Player.Functions.AddItem("grape", Config.GrapeAmount)
    TriggerClientEvent('inventory:client:ItemBox', source, NADRP.Shared.Items['grape'], "add")
end)

RegisterNetEvent('NADRP-vineyard:server:loadIngredients', function()
	local xPlayer = NADRP.Functions.GetPlayer(tonumber(source))
    local grape = xPlayer.Functions.GetItemByName('grapejuice')
	if xPlayer.PlayerData.items ~= nil then
        if grape ~= nil then
            if grape.amount >= 23 then
                xPlayer.Functions.RemoveItem("grapejuice", 23, false)
                TriggerClientEvent('inventory:client:ItemBox', source, NADRP.Shared.Items['grapejuice'], "remove")
                TriggerClientEvent("NADRP-vineyard:client:loadIngredients", source)
            else
                TriggerClientEvent('NADRP:Notify', source, Lang:t("error.invalid_items"), 'error')
            end
        else
            TriggerClientEvent('NADRP:Notify', source, Lang:t("error.invalid_items"), 'error')
        end
	else
		TriggerClientEvent('NADRP:Notify', source, Lang:t("error.no_items"), "error")
	end
end)

RegisterNetEvent('NADRP-vineyard:server:grapeJuice', function()
	local xPlayer = NADRP.Functions.GetPlayer(tonumber(source))
    local grape = xPlayer.Functions.GetItemByName('grape')
	if xPlayer.PlayerData.items ~= nil then
        if grape ~= nil then
            if grape.amount >= 16 then
                xPlayer.Functions.RemoveItem("grape", 16, false)
                TriggerClientEvent('inventory:client:ItemBox', source, NADRP.Shared.Items['grape'], "remove")
                TriggerClientEvent("NADRP-vineyard:client:grapeJuice", source)
            else
                TriggerClientEvent('NADRP:Notify', source, Lang:t("error.invalid_items"), 'error')
            end
        else
            TriggerClientEvent('NADRP:Notify', source, Lang:t("error.invalid_items"), 'error')
        end
	else
		TriggerClientEvent('NADRP:Notify', source, Lang:t("error.no_items"), "error")
	end
end)

RegisterNetEvent('NADRP-vineyard:server:receiveWine', function()
	local xPlayer = NADRP.Functions.GetPlayer(tonumber(source))
	xPlayer.Functions.AddItem("wine", Config.WineAmount, false)
	TriggerClientEvent('inventory:client:ItemBox', source, NADRP.Shared.Items['wine'], "add")
end)

RegisterNetEvent('NADRP-vineyard:server:receiveGrapeJuice', function()
	local xPlayer = NADRP.Functions.GetPlayer(tonumber(source))
	xPlayer.Functions.AddItem("grapejuice", Config.GrapeJuiceAmount, false)
	TriggerClientEvent('inventory:client:ItemBox', source, NADRP.Shared.Items['grapejuice'], "add")
end)
