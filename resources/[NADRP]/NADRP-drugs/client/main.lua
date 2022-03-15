NADRP = exports['NADRP-core']:GetCoreObject()

RegisterNetEvent('NADRP-drugs:AddWeapons', function()
    Config.Dealers[2]["products"][#Config.Dealers[2]["products"]+1] = {
        name = "weapon_snspistol",
        price = 5000,
        amount = 1,
        info = {
            serie = tostring(NADRP.Shared.RandomInt(2) .. NADRP.Shared.RandomStr(3) .. NADRP.Shared.RandomInt(1) .. NADRP.Shared.RandomStr(2) .. NADRP.Shared.RandomInt(3) .. NADRP.Shared.RandomStr(4))
        },
        type = "item",
        slot = 5,
        minrep = 200,
    }
    Config.Dealers[3]["products"][#Config.Dealers[3]["products"]+1] = {
        name = "weapon_snspistol",
        price = 5000,
        amount = 1,
        info = {
            serie = tostring(NADRP.Shared.RandomInt(2) .. NADRP.Shared.RandomStr(3) .. NADRP.Shared.RandomInt(1) .. NADRP.Shared.RandomStr(2) .. NADRP.Shared.RandomInt(3) .. NADRP.Shared.RandomStr(4))
        },
        type = "item",
        slot = 5,
        minrep = 200,
    }
end)