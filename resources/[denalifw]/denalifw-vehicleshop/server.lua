-- Variables
local DenaliFW = exports['denalifw-core']:GetCoreObject()
local financetimer = {}
local paymentDue = false

-- Handlers

-- Store game time for player when they load
RegisterNetEvent('denalifw-vehicleshop:server:addPlayer', function(citizenid, gameTime)
    financetimer[citizenid] = gameTime
end)

-- Deduct stored game time from player on logout
RegisterNetEvent('denalifw-vehicleshop:server:removePlayer', function(citizenid)
    if financetimer[citizenid] then
        local playTime = financetimer[citizenid]
        local financetime = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = ?', {citizenid})
        for k,v in pairs(financetime) do
            if v.balance >= 1 then
                local newTime = math.floor(v.financetime - (((GetGameTimer() - playTime) / 1000) / 60))
                if newTime < 0 then newTime = 0 end
                MySQL.Async.execute('UPDATE player_vehicles SET financetime = ? WHERE plate = ?', {newTime, v.plate})
            end
        end
    end
    financetimer[citizenid] = nil
end)

-- Deduct stored game time from player on quit because we can't get citizenid
AddEventHandler('playerDropped', function()
    local src = source
    for k,v in pairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        end
    end
    if license then
        local vehicles = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE license = ?', {license})
        if vehicles then
            for k,v in pairs(vehicles) do
                local playTime = financetimer[v.citizenid]
                if v.balance >= 1 and playTime then
                    local newTime = math.floor(v.financetime - (((GetGameTimer() - playTime) / 1000) / 60))
                    if newTime < 0 then newTime = 0 end
                    MySQL.Async.execute('UPDATE player_vehicles SET financetime = ? WHERE plate = ?', {newTime, v.plate})
                end
            end
            if vehicles[1] and financetimer[vehicles[1].citizenid] then financetimer[vehicles[1].citizenid] = nil end
        end
    end
end)

-- Functions

local function round(x)
    return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

local function calculateFinance(vehiclePrice, downPayment, paymentamount)
    local balance = vehiclePrice - downPayment
    local vehPaymentAmount = balance / paymentamount
    return round(balance), round(vehPaymentAmount)
end

local function calculateNewFinance(paymentAmount, vehData)
    local newBalance = tonumber(vehData.balance - paymentAmount)
    local minusPayment = vehData.paymentsLeft - 1
    local newPaymentsLeft = newBalance / minusPayment
    local newPayment = newBalance / newPaymentsLeft
    return round(newBalance), round(newPayment), newPaymentsLeft
end

local function GeneratePlate()
    local plate = DenaliFW.Shared.RandomInt(1) .. DenaliFW.Shared.RandomStr(2) .. DenaliFW.Shared.RandomInt(3) .. DenaliFW.Shared.RandomStr(2)
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return GeneratePlate()
    else
        return plate:upper()
    end
end

local function comma_value(amount)
    local formatted = amount
    while true do
      formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1,%2')
      if (k==0) then
        break
      end
    end
    return formatted
end

-- Callbacks

DenaliFW.Functions.CreateCallback('denalifw-vehicleshop:server:getVehicles', function(source, cb)
    local src = source
    local player = DenaliFW.Functions.GetPlayer(src)
    if player then
        local vehicles = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = ?', {player.PlayerData.citizenid})
        if vehicles[1] then
            cb(vehicles)
        end
    end
end)

-- Events

-- Sync vehicle for other players
RegisterNetEvent('denalifw-vehicleshop:server:swapVehicle', function(data)
    local src = source
    TriggerClientEvent('denalifw-vehicleshop:client:swapVehicle', -1, data)
    Wait(1500) -- let new car spawn
    TriggerClientEvent('denalifw-vehicleshop:client:homeMenu', src) -- reopen main menu
end)

-- Send customer for test drive
RegisterNetEvent('denalifw-vehicleshop:server:customTestDrive', function(vehicle, playerid)
    local src = source
    local target = tonumber(playerid)
    if not DenaliFW.Functions.GetPlayer(target) then
        TriggerClientEvent('DenaliFW:Notify', src, 'Invalid Player Id Supplied', 'error')
        return
    end
    if #(GetEntityCoords(GetPlayerPed(src))-GetEntityCoords(GetPlayerPed(target)))<3 then
        TriggerClientEvent('denalifw-vehicleshop:client:customTestDrive', target, vehicle)
    else
        TriggerClientEvent('DenaliFW:Notify', src, 'This player is not close enough', 'error')
    end
end)

-- Make a finance payment
RegisterNetEvent('denalifw-vehicleshop:server:financePayment', function(paymentAmount, vehData)
    local src = source
    local player = DenaliFW.Functions.GetPlayer(src)
    local cash = player.PlayerData.money['cash']
    local bank = player.PlayerData.money['bank']
    local plate = vehData.vehiclePlate
    local paymentAmount = tonumber(paymentAmount)
    local minPayment = tonumber(vehData.paymentAmount)
    local timer = (Config.PaymentInterval * 60)
    local newBalance, newPaymentsLeft, newPayment = calculateNewFinance(paymentAmount, vehData)
    if newBalance > 0 then
        if player and paymentAmount >= minPayment then
            if cash >= paymentAmount then
                player.Functions.RemoveMoney('cash', paymentAmount)
                MySQL.Async.execute('UPDATE player_vehicles SET balance = ?, paymentamount = ?, paymentsleft = ?, financetime = ? WHERE plate = ?', {newBalance, newPayment, newPaymentsLeft, timer, plate})
            elseif bank >= paymentAmount then
                player.Functions.RemoveMoney('bank', paymentAmount)
                MySQL.Async.execute('UPDATE player_vehicles SET balance = ?, paymentamount = ?, paymentsleft = ?, financetime = ? WHERE plate = ?', {newBalance, newPayment, newPaymentsLeft, timer, plate})
            else
                TriggerClientEvent('DenaliFW:Notify', src, 'Not enough money', 'error')
            end
        else
            TriggerClientEvent('DenaliFW:Notify', src, 'Minimum payment allowed is $' ..comma_value(minPayment), 'error')
        end
    else
        TriggerClientEvent('DenaliFW:Notify', src, 'You overpaid', 'error')
    end
end)


-- Pay off vehice in full
RegisterNetEvent('denalifw-vehicleshop:server:financePaymentFull', function(data)
    local src = source
    local player = DenaliFW.Functions.GetPlayer(src)
    local cash = player.PlayerData.money['cash']
    local bank = player.PlayerData.money['bank']
    local vehBalance = data.vehBalance
    local vehPlate = data.vehPlate
    if player and vehBalance ~= 0 then
        if cash >= vehBalance then
            player.Functions.RemoveMoney('cash', vehBalance)
            MySQL.Async.execute('UPDATE player_vehicles SET balance = ?, paymentamount = ?, paymentsleft = ?, financetime = ? WHERE plate = ?', {0, 0, 0, 0, vehPlate})
        elseif bank >= vehBalance then
            player.Functions.RemoveMoney('bank', vehBalance)
            MySQL.Async.execute('UPDATE player_vehicles SET balance = ?, paymentamount = ?, paymentsleft = ?, financetime = ? WHERE plate = ?', {0, 0, 0, 0, vehPlate})
        else
            TriggerClientEvent('DenaliFW:Notify', src, 'Not enough money', 'error')
        end
    else
        TriggerClientEvent('DenaliFW:Notify', src, 'Vehicle is already paid off', 'error')
    end
end)

-- Buy public vehicle outright
RegisterNetEvent('denalifw-vehicleshop:server:buyShowroomVehicle', function(vehicle)
    local src = source
    local vehicle = vehicle.buyVehicle
    local pData = DenaliFW.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local cash = pData.PlayerData.money['cash']
    local bank = pData.PlayerData.money['bank']
    local vehiclePrice = DenaliFW.Shared.Vehicles[vehicle]['price']
    local plate = GeneratePlate()
    if cash > vehiclePrice then
        MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            0
        })
        TriggerClientEvent('DenaliFW:Notify', src, 'Congratulations on your purchase!', 'success')
        TriggerClientEvent('denalifw-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('cash', vehiclePrice, 'vehicle-bought-in-showroom')
    elseif bank > vehiclePrice then
        MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            0
        })
        TriggerClientEvent('DenaliFW:Notify', src, 'Congratulations on your purchase!', 'success')
        TriggerClientEvent('denalifw-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('bank', vehiclePrice, 'vehicle-bought-in-showroom')
    else
        TriggerClientEvent('DenaliFW:Notify', src, 'Not enough money', 'error')
    end
end)

-- Finance public vehicle
RegisterNetEvent('denalifw-vehicleshop:server:financeVehicle', function(downPayment, paymentAmount, vehicle)
    local src = source
    local downPayment = tonumber(downPayment)
    local paymentAmount = tonumber(paymentAmount)
    local pData = DenaliFW.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local cash = pData.PlayerData.money['cash']
    local bank = pData.PlayerData.money['bank']
    local vehiclePrice = DenaliFW.Shared.Vehicles[vehicle]['price']
    local timer = (Config.PaymentInterval * 60)
    local minDown = tonumber(round((Config.MinimumDown/100) * vehiclePrice))
    if downPayment > vehiclePrice then return TriggerClientEvent('DenaliFW:Notify', src, 'Vehicle is not worth that much', 'error') end
    if downPayment < minDown then return TriggerClientEvent('DenaliFW:Notify', src, 'Down payment too small', 'error') end
    if paymentAmount > Config.MaximumPayments then return TriggerClientEvent('DenaliFW:Notify', src, 'Exceeded maximum payment amount', 'error') end
    local plate = GeneratePlate()
    local balance, vehPaymentAmount = calculateFinance(vehiclePrice, downPayment, paymentAmount)
    if cash >= downPayment then
        MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, balance, paymentamount, paymentsleft, financetime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            0,
            balance,
            vehPaymentAmount,
            paymentAmount,
            timer
        })
        TriggerClientEvent('DenaliFW:Notify', src, 'Congratulations on your purchase!', 'success')
        TriggerClientEvent('denalifw-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('cash', downPayment, 'vehicle-bought-in-showroom')
    elseif bank >= downPayment then
        MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, balance, paymentamount, paymentsleft, financetime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            0,
            balance,
            vehPaymentAmount,
            paymentAmount,
            timer
        })
        TriggerClientEvent('DenaliFW:Notify', src, 'Congratulations on your purchase!', 'success')
        TriggerClientEvent('denalifw-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('bank', downPayment, 'vehicle-bought-in-showroom')
    else
        TriggerClientEvent('DenaliFW:Notify', src, 'Not enough money', 'error')
    end
end)

-- Sell vehicle to customer
RegisterNetEvent('denalifw-vehicleshop:server:sellShowroomVehicle', function(data, playerid)
    local src = source
    local player = DenaliFW.Functions.GetPlayer(src)
    local target = DenaliFW.Functions.GetPlayer(tonumber(playerid))

    if not target then
        TriggerClientEvent('DenaliFW:Notify', src, 'Invalid Player Id Supplied', 'error')
        return
    end

    if #(GetEntityCoords(GetPlayerPed(src))-GetEntityCoords(GetPlayerPed(target.PlayerData.source)))<3 then
        local cid = target.PlayerData.citizenid
        local cash = target.PlayerData.money['cash']
        local bank = target.PlayerData.money['bank']
        local vehicle = data
        local vehiclePrice = DenaliFW.Shared.Vehicles[vehicle]['price']
        local plate = GeneratePlate()
        if cash >= vehiclePrice then
            MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
                target.PlayerData.license,
                cid,
                vehicle,
                GetHashKey(vehicle),
                '{}',
                plate,
                0
            })
            TriggerClientEvent('denalifw-vehicleshop:client:buyShowroomVehicle', target.PlayerData.source, vehicle, plate)
            target.Functions.RemoveMoney('cash', vehiclePrice, 'vehicle-bought-in-showroom')
            TriggerEvent('denalifw-bossmenu:server:addAccountMoney', player.PlayerData.job.name, vehiclePrice)
            TriggerClientEvent('DenaliFW:Notify', target.PlayerData.source, 'Congratulations on your purchase!', 'success')
        elseif bank >= vehiclePrice then
            MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
                target.PlayerData.license,
                cid,
                vehicle,
                GetHashKey(vehicle),
                '{}',
                plate,
                0
            })
            TriggerClientEvent('denalifw-vehicleshop:client:buyShowroomVehicle', target.PlayerData.source, vehicle, plate)
            target.Functions.RemoveMoney('bank', vehiclePrice, 'vehicle-bought-in-showroom')
            TriggerEvent('denalifw-bossmenu:server:addAccountMoney', player.PlayerData.job.name, vehiclePrice)
            TriggerClientEvent('DenaliFW:Notify', target.PlayerData.source, 'Congratulations on your purchase!', 'success')
        else
            TriggerClientEvent('DenaliFW:Notify', src, 'Not enough money', 'error')
        end
    else
        TriggerClientEvent('DenaliFW:Notify', src, 'This player is not close enough', 'error')
    end
end)

-- Finance vehicle to customer
RegisterNetEvent('denalifw-vehicleshop:server:sellfinanceVehicle', function(downPayment, paymentAmount, vehicle, playerid)
    local src = source
    local player = DenaliFW.Functions.GetPlayer(src)
    local target = DenaliFW.Functions.GetPlayer(tonumber(playerid))

    if not target then
        TriggerClientEvent('DenaliFW:Notify', src, 'Invalid Player Id Supplied', 'error')
        return
    end

    if #(GetEntityCoords(GetPlayerPed(src))-GetEntityCoords(GetPlayerPed(target.PlayerData.source)))<3 then
        local downPayment = tonumber(downPayment)
        local paymentAmount = tonumber(paymentAmount)
        local cid = target.PlayerData.citizenid
        local cash = target.PlayerData.money['cash']
        local bank = target.PlayerData.money['bank']
        local vehiclePrice = DenaliFW.Shared.Vehicles[vehicle]['price']
        local timer = (Config.PaymentInterval * 60)
        local minDown = tonumber(round((Config.MinimumDown/100) * vehiclePrice))
        if downPayment > vehiclePrice then return TriggerClientEvent('DenaliFW:Notify', src, 'Vehicle is not worth that much', 'error') end
        if downPayment < minDown then return TriggerClientEvent('DenaliFW:Notify', src, 'Down payment too small', 'error') end
        if paymentAmount > Config.MaximumPayments then return TriggerClientEvent('DenaliFW:Notify', src, 'Exceeded maximum payment amount', 'error') end
        local plate = GeneratePlate()
        local balance, vehPaymentAmount = calculateFinance(vehiclePrice, downPayment, paymentAmount)
        if cash >= downPayment then
            MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, balance, paymentamount, paymentsleft, financetime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
                target.PlayerData.license,
                cid,
                vehicle,
                GetHashKey(vehicle),
                '{}',
                plate,
                0,
                balance,
                vehPaymentAmount,
                paymentAmount,
                timer
            })
            TriggerClientEvent('denalifw-vehicleshop:client:buyShowroomVehicle', target.PlayerData.source, vehicle, plate)
            target.Functions.RemoveMoney('cash', downPayment, 'vehicle-bought-in-showroom')
            TriggerEvent('denalifw-bossmenu:server:addAccountMoney', player.PlayerData.job.name, vehiclePrice)
            TriggerClientEvent('DenaliFW:Notify', target.PlayerData.source, 'Congratulations on your purchase!', 'success')
        elseif bank >= downPayment then
            MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, balance, paymentamount, paymentsleft, financetime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
                target.PlayerData.license,
                cid,
                vehicle,
                GetHashKey(vehicle),
                '{}',
                plate,
                0,
                balance,
                vehPaymentAmount,
                paymentAmount,
                timer
            })
            TriggerClientEvent('denalifw-vehicleshop:client:buyShowroomVehicle', target.PlayerData.source, vehicle, plate)
            target.Functions.RemoveMoney('bank', downPayment, 'vehicle-bought-in-showroom')
            TriggerEvent('denalifw-bossmenu:server:addAccountMoney', player.PlayerData.job.name, vehiclePrice)
            TriggerClientEvent('DenaliFW:Notify', target.PlayerData.source, 'Congratulations on your purchase!', 'success')
        else
            TriggerClientEvent('DenaliFW:Notify', src, 'Not enough money', 'error')
        end
    else
        TriggerClientEvent('DenaliFW:Notify', src, 'This player is not close enough', 'error')
    end
end)

-- Check if payment is due
RegisterNetEvent('denalifw-vehicleshop:server:checkFinance', function()
    local src = source
    local player = DenaliFW.Functions.GetPlayer(src)
    local result = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = ?', {player.PlayerData.citizenid})
    for k,v in pairs(result) do
        if v.balance >= 1 and v.financetime < 1 then
            paymentDue = true
        end
    end
    if paymentDue then
        TriggerClientEvent('DenaliFW:Notify', src, 'Your vehicle payment is due within '..Config.PaymentWarning..' minutes')
        Wait(Config.PaymentWarning * 60000)
        MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = ?', {player.PlayerData.citizenid}, function(vehicles)
            for k,v in pairs(vehicles) do
                if v.balance >= 1 and v.financetime < 1 then
                    local plate = v.plate
                    MySQL.Async.execute('DELETE FROM player_vehicles WHERE plate = @plate', {['@plate'] = plate})
                    TriggerClientEvent('DenaliFW:Notify', src, 'Your vehicle with plate '..plate..' has been repossessed', 'error')
                end
            end
        end)
    end
end)

-- Transfer vehicle to player in passenger seat
DenaliFW.Commands.Add('transferVehicle', 'Gift or sell your vehicle', {{ name = 'amount', help = 'Sell amount' }}, false, function(source, args)
    local src = source
    local ped = GetPlayerPed(src)
    local player = DenaliFW.Functions.GetPlayer(src)
    local citizenid = player.PlayerData.citizenid
    local sellAmount = tonumber(args[1])
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then return TriggerClientEvent('DenaliFW:Notify', src, 'Must be in a vehicle', 'error') end
    local driver = GetPedInVehicleSeat(vehicle, -1)
    local passenger = GetPedInVehicleSeat(vehicle, 0)
    local plate = DenaliFW.Functions.GetPlate(vehicle)
    local isOwned = MySQL.Sync.fetchScalar('SELECT citizenid FROM player_vehicles WHERE plate = ?', {plate})
    if isOwned ~= citizenid then return TriggerClientEvent('DenaliFW:Notify', src, 'You dont own this vehicle', 'error') end
    if ped ~= driver then return TriggerClientEvent('DenaliFW:Notify', src, 'Must be driver', 'error') end
    if passenger == 0 then return TriggerClientEvent('DenaliFW:Notify', src, 'No passenger', 'error') end
    local targetid = NetworkGetEntityOwner(passenger)
    local target = DenaliFW.Functions.GetPlayer(targetid)
    if not target then return TriggerClientEvent('DenaliFW:Notify', src, 'Couldnt get passenger info', 'error') end
    if sellAmount then
        if target.Functions.GetMoney('cash') > sellAmount then
            local targetcid = target.PlayerData.citizenid
            MySQL.Async.execute('UPDATE player_vehicles SET citizenid = ? WHERE plate = ?', {targetcid, plate})
            player.Functions.AddMoney('cash', sellAmount)
            TriggerClientEvent('DenaliFW:Notify', src, 'You sold your vehicle for $'..comma_value(sellAmount), 'success')
            target.Functions.RemoveMoney('cash', sellAmount)
            TriggerClientEvent('vehiclekeys:client:SetOwner', target.PlayerData.source, plate)
            TriggerClientEvent('DenaliFW:Notify', target.PlayerData.source, 'You bought a vehicle for $'..comma_value(sellAmount), 'success')
        else
            TriggerClientEvent('DenaliFW:Notify', src, 'Not enough money', 'error')
        end
    else
        local targetcid = target.PlayerData.citizenid
        MySQL.Async.execute('UPDATE player_vehicles SET citizenid = ? WHERE plate = ?', {targetcid, plate})
        TriggerClientEvent('DenaliFW:Notify', src, 'You gifted your vehicle', 'success')
        TriggerClientEvent('vehiclekeys:client:SetOwner', target.PlayerData.source, plate)
        TriggerClientEvent('DenaliFW:Notify', target.PlayerData.source, 'You were gifted a vehicle', 'success')
    end
end, 'user')
