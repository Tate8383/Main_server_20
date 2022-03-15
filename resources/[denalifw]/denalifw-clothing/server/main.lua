local DenaliFW = exports['denalifw-core']:GetCoreObject()

RegisterServerEvent("denalifw-clothing:saveSkin")
AddEventHandler('denalifw-clothing:saveSkin', function(model, skin)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    if model ~= nil and skin ~= nil then
        -- TODO: Update primary key to be citizenid so this can be an insert on duplicate update query
        MySQL.Async.execute('DELETE FROM playerskins WHERE citizenid = ?', { Player.PlayerData.citizenid }, function()
            MySQL.Async.insert('INSERT INTO playerskins (citizenid, model, skin, active) VALUES (?, ?, ?, ?)', {
                Player.PlayerData.citizenid,
                model,
                skin,
                1
            })
        end)
    end
end)

RegisterServerEvent("denalifw-clothes:loadPlayerSkin")
AddEventHandler('denalifw-clothes:loadPlayerSkin', function()
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    local result = MySQL.Sync.fetchAll('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', { Player.PlayerData.citizenid, 1 })
    if result[1] ~= nil then
        TriggerClientEvent("denalifw-clothes:loadSkin", src, false, result[1].model, result[1].skin)
    else
        TriggerClientEvent("denalifw-clothes:loadSkin", src, true)
    end
end)

RegisterServerEvent("denalifw-clothes:saveOutfit")
AddEventHandler("denalifw-clothes:saveOutfit", function(outfitName, model, skinData)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    if model ~= nil and skinData ~= nil then
        local outfitId = "outfit-"..math.random(1, 10).."-"..math.random(1111, 9999)
        MySQL.Async.insert('INSERT INTO player_outfits (citizenid, outfitname, model, skin, outfitId) VALUES (?, ?, ?, ?, ?)', {
            Player.PlayerData.citizenid,
            outfitName,
            model,
            json.encode(skinData),
            outfitId
        }, function()
            local result = MySQL.Sync.fetchAll('SELECT * FROM player_outfits WHERE citizenid = ?', { Player.PlayerData.citizenid })
            if result[1] ~= nil then
                TriggerClientEvent('denalifw-clothing:client:reloadOutfits', src, result)
            else
                TriggerClientEvent('denalifw-clothing:client:reloadOutfits', src, nil)
            end
        end)
    end
end)

RegisterServerEvent("denalifw-clothing:server:removeOutfit")
AddEventHandler("denalifw-clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    MySQL.Async.execute('DELETE FROM player_outfits WHERE citizenid = ? AND outfitname = ? AND outfitId = ?', {
        Player.PlayerData.citizenid,
        outfitName,
        outfitId
    }, function()
        local result = MySQL.Sync.fetchAll('SELECT * FROM player_outfits WHERE citizenid = ?', { Player.PlayerData.citizenid })
        if result[1] ~= nil then
            TriggerClientEvent('denalifw-clothing:client:reloadOutfits', src, result)
        else
            TriggerClientEvent('denalifw-clothing:client:reloadOutfits', src, nil)
        end
    end)
end)

DenaliFW.Functions.CreateCallback('denalifw-clothing:server:getOutfits', function(source, cb)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    local anusVal = {}

    local result = MySQL.Sync.fetchAll('SELECT * FROM player_outfits WHERE citizenid = ?', { Player.PlayerData.citizenid })
    if result[1] ~= nil then
        for k, v in pairs(result) do
            result[k].skin = json.decode(result[k].skin)
            anusVal[k] = v
        end
        cb(anusVal)
    end
    cb(anusVal)
end)