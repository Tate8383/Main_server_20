local DenaliFW = exports['denalifw-core']:GetCoreObject()

DenaliFW.Commands.Add("binds", "Open commandbinding menu", {}, false, function(source, args)
    local Player = DenaliFW.Functions.GetPlayer(source)
	TriggerClientEvent("denalifw-commandbinding:client:openUI", source)
end)

RegisterNetEvent('denalifw-commandbinding:server:setKeyMeta', function(keyMeta)
    local src = source
    local ply = DenaliFW.Functions.GetPlayer(src)

    ply.Functions.SetMetaData("commandbinds", keyMeta)
end)
