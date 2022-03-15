local DenaliFW = exports['denalifw-core']:GetCoreObject()

DenaliFW.Commands.Add('me', 'Me message.', {}, false, function(source, args)
	if source == 0 or source == "Console" then return end

	args = table.concat(args, ' ')
	TriggerClientEvent('u7x!A%D*', -1, source, args, "me")
end)

DenaliFW.Commands.Add('do', 'Do message.', {}, false, function(source, args)
	if source == 0 then return end

	args = table.concat(args, ' ')
	TriggerClientEvent('u7x!A%D*', -1, source, args, "do")
end)