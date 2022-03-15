local DenaliFW = exports['denalifw-core']:GetCoreObject()

DenaliFW.Functions.CreateUseableItem("fitbit", function(source, item)
    local Player = DenaliFW.Functions.GetPlayer(source)
    TriggerClientEvent('denalifw-fitbit:use', source)
end)

RegisterNetEvent('denalifw-fitbit:server:setValue', function(type, value)
    local src = source
    local ply = DenaliFW.Functions.GetPlayer(src)
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

DenaliFW.Functions.CreateCallback('denalifw-fitbit:server:HasFitbit', function(source, cb)
    local Ply = DenaliFW.Functions.GetPlayer(source)
    local Fitbit = Ply.Functions.GetItemByName("fitbit")

    if Fitbit ~= nil then
        cb(true)
    else
        cb(false)
    end
end)
