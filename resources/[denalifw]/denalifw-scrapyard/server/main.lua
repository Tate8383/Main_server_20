local DenaliFW = exports['denalifw-core']:GetCoreObject()

CreateThread(function()
    while true do
        Wait(1000)
        GenerateVehicleList()
        Wait((1000 * 60) * 60)
    end
end)

RegisterNetEvent('denalifw-scrapyard:server:LoadVehicleList', function()
    local src = source
    TriggerClientEvent("denalifw-scapyard:client:setNewVehicles", src, Config.CurrentVehicles)
end)


DenaliFW.Functions.CreateCallback('denalifw-scrapyard:checkOwnerVehicle', function(source, cb, plate)
    local result = MySQL.Sync.fetchScalar("SELECT `plate` FROM `player_vehicles` WHERE `plate` = ?",{plate})
    if result then
        cb(false)
    else
        cb(true)
    end
end)


RegisterNetEvent('denalifw-scrapyard:server:ScrapVehicle', function(listKey)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    if Config.CurrentVehicles[listKey] ~= nil then
        for i = 1, math.random(2, 4), 1 do
            local item = Config.Items[math.random(1, #Config.Items)]
            Player.Functions.AddItem(item, math.random(25, 45))
            TriggerClientEvent('inventory:client:ItemBox', src, DenaliFW.Shared.Items[item], 'add')
            Wait(500)
        end
        local Luck = math.random(1, 8)
        local Odd = math.random(1, 8)
        if Luck == Odd then
            local random = math.random(10, 20)
            Player.Functions.AddItem("rubber", random)
            TriggerClientEvent('inventory:client:ItemBox', src, DenaliFW.Shared.Items["rubber"], 'add')

        end
        Config.CurrentVehicles[listKey] = nil
        TriggerClientEvent("denalifw-scapyard:client:setNewVehicles", -1, Config.CurrentVehicles)
    end
end)

function GenerateVehicleList()
    Config.CurrentVehicles = {}
    for i = 1, 40, 1 do
        local randVehicle = Config.Vehicles[math.random(1, #Config.Vehicles)]
        if not IsInList(randVehicle) then
            Config.CurrentVehicles[i] = randVehicle
        end
    end
    TriggerClientEvent("denalifw-scapyard:client:setNewVehicles", -1, Config.CurrentVehicles)
end

function IsInList(name)
    local retval = false
    if Config.CurrentVehicles ~= nil and next(Config.CurrentVehicles) ~= nil then
        for k, v in pairs(Config.CurrentVehicles) do
            if Config.CurrentVehicles[k] == name then
                retval = true
            end
        end
    end
    return retval
end