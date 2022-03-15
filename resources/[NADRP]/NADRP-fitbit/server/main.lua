local NADRP = exports['NADRP-core']:GetCoreObject()

NADRP.Functions.CreateUseableItem("fitbit", function(source, item)
    local Player = NADRP.Functions.GetPlayer(source)
    TriggerClientEvent('NADRP-fitbit:use', source)
end)

RegisterNetEvent('NADRP-fitbit:server:setValue', function(type, value)
    local src = source
    local ply = NADRP.Functions.GetPlayer(src)
    local fitbitData = {}

    if type == "thirst" then
        local currentMeta = ply.PlayerData.metadata["fitbit"]
        fitbitData = {
            thirst = value,
            food = currentMeta.food
        }
    elseif type == "food" then
        local currentMeta = ply.PlayerData.metadata["fitbit"]
        fitbitData = {
            thirst = currentMeta.thirst,
            food = value
        }
    end

    ply.Functions.SetMetaData('fitbit', fitbitData)
end)

NADRP.Functions.CreateCallback('NADRP-fitbit:server:HasFitbit', function(source, cb)
    local Ply = NADRP.Functions.GetPlayer(source)
    local Fitbit = Ply.Functions.GetItemByName("fitbit")

    if Fitbit ~= nil then
        cb(true)
    else
        cb(false)
    end
end)
