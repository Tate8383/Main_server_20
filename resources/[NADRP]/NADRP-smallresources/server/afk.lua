local NADRP = exports['NADRP-core']:GetCoreObject()

RegisterNetEvent('KickForAFK', function()
    local src = source
	DropPlayer(src, 'You Have Been Kicked For Being AFK')
end)

NADRP.Functions.CreateCallback('NADRP-afkkick:server:GetPermissions', function(source, cb)
    local src = source
    local group = NADRP.Functions.GetPermission(src)
    cb(group)
end)
