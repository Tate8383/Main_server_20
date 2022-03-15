
NADRP = nil
local NADRP = exports['NADRP-core']:GetCoreObject()

Citizen.CreateThread(function()
	while true do
		Wait(60*30000) -- change time of payment
		TriggerServerEvent('NADRP-taxes')
	end
end)
