local NADRP = exports['NADRP-core']:GetCoreObject()

RegisterNetEvent('NADRP-shops:server:UpdateShopItems', function(shop, itemData, amount)
    Config.Locations[shop]["products"][itemData.slot].amount =  Config.Locations[shop]["products"][itemData.slot].amount - amount
    if Config.Locations[shop]["products"][itemData.slot].amount <= 0 then 
        Config.Locations[shop]["products"][itemData.slot].amount = 0
    end
    TriggerClientEvent('NADRP-shops:client:SetShopItems', -1, shop, Config.Locations[shop]["products"])
end)

RegisterNetEvent('NADRP-shops:server:RestockShopItems', function(shop)
    if Config.Locations[shop]["products"] ~= nil then 
        local randAmount = math.random(10, 50)
        for k, v in pairs(Config.Locations[shop]["products"]) do 
            Config.Locations[shop]["products"][k].amount = Config.Locations[shop]["products"][k].amount + randAmount
        end
        TriggerClientEvent('NADRP-shops:client:RestockShopItems', -1, shop, randAmount)
    end
end)

NADRP.Functions.CreateCallback('NADRP-shops:server:getLicenseStatus', function(source, cb)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
    local licenseTable = Player.PlayerData.metadata["licences"]
    local licenseItem = Player.Functions.GetItemByName("weaponlicense")
    cb(licenseTable.weapon, licenseItem)
end)
