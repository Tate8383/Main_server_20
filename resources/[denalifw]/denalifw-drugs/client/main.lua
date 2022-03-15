DenaliFW = exports['denalifw-core']:GetCoreObject()

RegisterNetEvent('denalifw-drugs:AddWeapons', function()
    Config.Dealers[2]["products"][#Config.Dealers[2]["products"]+1] = {
        name = "weapon_snspistol",
        price = 5000,
        amount = 1,
        info = {
            serie = tostring(DenaliFW.Shared.RandomInt(2) .. DenaliFW.Shared.RandomStr(3) .. DenaliFW.Shared.RandomInt(1) .. DenaliFW.Shared.RandomStr(2) .. DenaliFW.Shared.RandomInt(3) .. DenaliFW.Shared.RandomStr(4))
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
            serie = tostring(DenaliFW.Shared.RandomInt(2) .. DenaliFW.Shared.RandomStr(3) .. DenaliFW.Shared.RandomInt(1) .. DenaliFW.Shared.RandomStr(2) .. DenaliFW.Shared.RandomInt(3) .. DenaliFW.Shared.RandomStr(4))
        },
        type = "item",
        slot = 5,
        minrep = 200,
    }
end)