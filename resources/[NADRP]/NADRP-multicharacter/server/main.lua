local NADRP = exports['NADRP-core']:GetCoreObject()

-- Functions

local function GiveStarterItems(source)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)

    for k, v in pairs(NADRP.Shared.StarterItems) do
        local info = {}
        if v.item == "id_card" then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif v.item == "driver_license" then
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.type = "Class C Driver License"
        end
        Player.Functions.AddItem(v.item, v.amount, false, info)
    end
end

local function loadHouseData()
    local HouseGarages = {}
    local Houses = {}
    local result = MySQL.Sync.fetchAll('SELECT * FROM houselocations', {})
    if result[1] ~= nil then
        for k, v in pairs(result) do
            local owned = false
            if tonumber(v.owned) == 1 then
                owned = true
            end
            local garage = v.garage ~= nil and json.decode(v.garage) or {}
            Houses[v.name] = {
                coords = json.decode(v.coords),
                owned = v.owned,
                price = v.price,
                locked = true,
                adress = v.label,
                tier = v.tier,
                garage = garage,
                decorations = {},
            }
            HouseGarages[v.name] = {
                label = v.label,
                takeVehicle = garage,
            }
        end
    end
    TriggerClientEvent("NADRP-garages:client:houseGarageConfig", -1, HouseGarages)
    TriggerClientEvent("NADRP-houses:client:setHouseConfig", -1, Houses)
end

-- Commands

NADRP.Commands.Add("logout", "Logout of Character (Admin Only)", {}, false, function(source)
    local src = source
    NADRP.Player.Logout(src)
    TriggerClientEvent('NADRP-multicharacter:client:chooseChar', src)
end, "admin")

NADRP.Commands.Add("closeNUI", "Close Multi NUI", {}, false, function(source)
    local src = source
    TriggerClientEvent('NADRP-multicharacter:client:closeNUI', src)
end)

-- Events

RegisterNetEvent('NADRP-multicharacter:server:disconnect', function()
    local src = source
    DropPlayer(src, "You have disconnected from NADRP")
end)

RegisterNetEvent('NADRP-multicharacter:server:loadUserData', function(cData)
    local src = source
    if NADRP.Player.Login(src, cData.citizenid) then
        print('^2[NADRP-core]^7 '..GetPlayerName(src)..' (Citizen ID: '..cData.citizenid..') has succesfully loaded!')
        NADRP.Commands.Refresh(src)
        loadHouseData()
        TriggerClientEvent('apartments:client:setupSpawnUI', src, cData)
        TriggerEvent("NADRP-log:server:CreateLog", "joinleave", "Loaded", "green", "**".. GetPlayerName(src) .. "** ("..(NADRP.Functions.GetIdentifier(src, 'discord') or 'undefined') .." |  ||"  ..(NADRP.Functions.GetIdentifier(src, 'ip') or 'undefined') ..  "|| | " ..(NADRP.Functions.GetIdentifier(src, 'license') or 'undefined') .." | " ..cData.citizenid.." | "..src..") loaded..")
	end
end)

RegisterNetEvent('NADRP-multicharacter:server:createCharacter', function(data)
    local src = source
    local newData = {}
    newData.cid = data.cid
    newData.charinfo = data
    if NADRP.Player.Login(src, false, newData) then
        if Config.StartingApartment then
            local randbucket = (GetPlayerPed(src) .. math.random(1,999))
            SetPlayerRoutingBucket(src, randbucket)
            print('^2[NADRP-core]^7 '..GetPlayerName(src)..' has succesfully loaded!')
            NADRP.Commands.Refresh(src)
            loadHouseData()
            TriggerClientEvent("NADRP-multicharacter:client:closeNUI", src)
            TriggerClientEvent('apartments:client:setupSpawnUI', src, newData)
            GiveStarterItems(src)
        else
            print('^2[NADRP-core]^7 '..GetPlayerName(src)..' has succesfully loaded!')
            NADRP.Commands.Refresh(src)
            loadHouseData()
            TriggerClientEvent("NADRP-multicharacter:client:closeNUIdefault", src)
            GiveStarterItems(src)
        end
	end
end)

RegisterNetEvent('NADRP-multicharacter:server:deleteCharacter', function(citizenid)
    local src = source
    NADRP.Player.DeleteCharacter(src, citizenid)
end)

-- Callbacks

NADRP.Functions.CreateCallback("NADRP-multicharacter:server:GetUserCharacters", function(source, cb)
    local src = source
    local license = NADRP.Functions.GetIdentifier(src, 'license')

    MySQL.Async.execute('SELECT * FROM players WHERE license = ?', {license}, function(result)
        cb(result)
    end)
end)

NADRP.Functions.CreateCallback("NADRP-multicharacter:server:GetServerLogs", function(source, cb)
    MySQL.Async.execute('SELECT * FROM server_logs', {}, function(result)
        cb(result)
    end)
end)

NADRP.Functions.CreateCallback("NADRP-multicharacter:server:setupCharacters", function(source, cb)
    local license = NADRP.Functions.GetIdentifier(source, 'license')
    local plyChars = {}
    MySQL.Async.fetchAll('SELECT * FROM players WHERE license = ?', {license}, function(result)
        for i = 1, (#result), 1 do
            result[i].charinfo = json.decode(result[i].charinfo)
            result[i].money = json.decode(result[i].money)
            result[i].job = json.decode(result[i].job)
            plyChars[#plyChars+1] = result[i]
        end
        cb(plyChars)
    end)
end)

NADRP.Functions.CreateCallback("NADRP-multicharacter:server:getSkin", function(source, cb, cid)
    local result = MySQL.Sync.fetchAll('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', {cid, 1})
    if result[1] ~= nil then
        cb(result[1].model, result[1].skin)
    else
        cb(nil)
    end
end)
