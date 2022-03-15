local NADRP = exports['NADRP-core']:GetCoreObject()

NADRP.Commands.Add("binds", "Open commandbinding menu", {}, false, function(source, args)
    local Player = NADRP.Functions.GetPlayer(source)
	TriggerClientEvent("NADRP-commandbinding:client:openUI", source)
end)

RegisterNetEvent('NADRP-commandbinding:server:setKeyMeta', function(keyMeta)
    local src = source
    local ply = NADRP.Functions.GetPlayer(src)

    ply.Functions.SetMetaData("commandbinds", keyMeta)
end)
