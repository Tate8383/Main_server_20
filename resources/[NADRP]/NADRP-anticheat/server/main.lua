local NADRP = exports['NADRP-core']:GetCoreObject()

-- Get permissions --

NADRP.Functions.CreateCallback('NADRP-anticheat:server:GetPermissions', function(source, cb)
    local group = NADRP.Functions.GetPermission(source)
    cb(group)
end)

-- Execute ban --

RegisterNetEvent('NADRP-anticheat:server:banPlayer', function(reason)
    local src = source
    TriggerEvent("NADRP-log:server:CreateLog", "anticheat", "Anti-Cheat", "white", GetPlayerName(src).." has been banned for "..reason, false)
    exports.oxmysql:insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        GetPlayerName(src),
        NADRP.Functions.GetIdentifier(src, 'license'),
        NADRP.Functions.GetIdentifier(src, 'discord'),
        NADRP.Functions.GetIdentifier(src, 'ip'),
        reason,
        2145913200,
        'Anti-Cheat'
    })
    DropPlayer(src, "You have been banned for cheating. Check our Discord for more information: " .. NADRP.Config.Server.discord)
end)

-- Fake events --
function NonRegisteredEventCalled(CalledEvent, source)
    TriggerClientEvent("NADRP-anticheat:client:NonRegisteredEventCalled", source, "Cheating", CalledEvent)
end

for x, v in pairs(Config.BlacklistedEvents) do
    RegisterServerEvent(v)
    AddEventHandler(v, function(source)
        NonRegisteredEventCalled(v, source)
    end)
end

-- RegisterServerEvent('banking:withdraw')
-- AddEventHandler('banking:withdraw', function(source)
--     NonRegisteredEventCalled('bank:withdraw', source)
-- end)

NADRP.Functions.CreateCallback('NADRP-anticheat:server:HasWeaponInInventory', function(source, cb, WeaponInfo)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
    local PlayerInventory = Player.PlayerData.items
    local retval = false

    for k, v in pairs(PlayerInventory) do
        if v.name == WeaponInfo["name"] then
            retval = true
        end
    end
    cb(retval)
end)
