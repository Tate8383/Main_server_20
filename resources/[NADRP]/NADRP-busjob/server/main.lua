local denalifw = exports['denalifw-core']:GetCoreObject()

function NearBus(src)
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    for k,v in pairs(Config.NPCLocations.Locations) do
        local dist = #(coords - vector3(v.x,v.y,v.z))
        if dist < 20 then
            return true
        end
    end
end

RegisterNetEvent('denalifw-busjob:server:NpcPay', function(Payment)
    local src = source
    local Player = denalifw.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "bus" then
        if NearBus(src) then
            local randomAmount = math.random(1, 5)
            local r1, r2 = math.random(1, 5), math.random(1, 5)
            if randomAmount == r1 or randomAmount == r2 then Payment = Payment + math.random(10, 20) end
            Player.Functions.AddMoney('cash', Payment)
        else
            DropPlayer(src, 'Attempting To Exploit')
        end
    else
        DropPlayer(src, 'Attempting To Exploit')
    end
end)
