
DenaliFW = nil
local DenaliFW = exports['denalifw-core']:GetCoreObject()

Citizen.CreateThread(function()
	while true do
		Wait(60*30000) -- change time of payment
		TriggerServerEvent('denalifw-taxes')
	end
end)
