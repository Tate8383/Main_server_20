local DenaliFW = exports['denalifw-core']:GetCoreObject()

-- Get permissions --

DenaliFW.Functions.CreateCallback('denalifw-anticheat:server:GetPermissions', function(source, cb)
    local group = DenaliFW.Functions.GetPermission(source)
    cb(group)
end)

-- Execute ban --

RegisterNetEvent('denalifw-anticheat:server:banPlayer', function(reason)
    local src = source
    TriggerEvent("denalifw-log:server:CreateLog", "anticheat", "Anti-Cheat", "white", GetPlayerName(src).." has been banned for "..reason, false)
    exports.oxmysql:insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        GetPlayerName(src),
        DenaliFW.Functions.GetIdentifier(src, 'license'),
        DenaliFW.Functions.GetIdentifier(src, 'discord'),
        DenaliFW.Functions.GetIdentifier(src, 'ip'),
        reason,
        2145913200,
        'Anti-Cheat'
    })
    DropPlayer(src, "You have been banned for cheating. Check our Discord for more information: " .. DenaliFW.Config.Server.discord)
end)

-- Fake events --
function NonRegisteredEventCalled(CalledEvent, source)
    TriggerClientEvent("denalifw-anticheat:client:NonRegisteredEventCalled", source, "Cheating", CalledEvent)
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

DenaliFW.Functions.CreateCallback('denalifw-anticheat:server:HasWeaponInInventory', function(source, cb, WeaponInfo)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    local PlayerInventory = Player.PlayerData.items
    local retval = false

    for k, v in pairs(PlayerInventory) do
        if v.name == WeaponInfo["name"] then
            retval = true
        end
    end
    cb(retval)
end)
