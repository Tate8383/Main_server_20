local denalifw = exports['denalifw-core']:GetCoreObject()

denalifw.Functions.CreateUseableItem("fitbit", function(source, item)
    local Player = denalifw.Functions.GetPlayer(source)
    TriggerClientEvent('denalifw-fitbit:use', source)
end)

RegisterNetEvent('denalifw-fitbit:server:setValue', function(type, value)
    local src = source
    local ply = denalifw.Functions.GetPlayer(src)
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

denalifw.Functions.CreateCallback('denalifw-fitbit:server:HasFitbit', function(source, cb)
    local Ply = denalifw.Functions.GetPlayer(source)
    local Fitbit = Ply.Functions.GetItemByName("fitbit")

    if Fitbit ~= nil then
        cb(true)
    else
        cb(false)
    end
end)
