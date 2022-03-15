local denalifw = exports['denalifw-core']:GetCoreObject()

RegisterNetEvent('fuel:pay', function(price, source)
	local xPlayer = denalifw.Functions.GetPlayer(source)
	local amount = math.floor(price + 0.5)

	if price > 0 then
		xPlayer.Functions.RemoveMoney('cash', amount)
	end
end)
