local NADRP = exports['NADRP-core']:GetCoreObject()

CreateThread(function()
	for i, v in pairs(NADRP.Shared.Vehicles) do
		local text
		if v["brand"] then
			text = v["brand"] .. " " .. v["name"]
		else
			text = v["name"]
		end
		AddTextEntryByHash(v["hash"],text)
	end
end)
