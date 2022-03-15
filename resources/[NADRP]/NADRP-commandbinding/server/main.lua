local denalifw = exports['denalifw-core']:GetCoreObject()

denalifw.Commands.Add("binds", "Open commandbinding menu", {}, false, function(source, args)
    local Player = denalifw.Functions.GetPlayer(source)
	TriggerClientEvent("denalifw-commandbinding:client:openUI", source)
end)

RegisterNetEvent('denalifw-commandbinding:server:setKeyMeta', function(keyMeta)
    local src = source
    local ply = denalifw.Functions.GetPlayer(src)

    ply.Functions.SetMetaData("commandbinds", keyMeta)
end)
