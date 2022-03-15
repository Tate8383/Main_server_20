DenaliFW = exports['denalifw-core']:GetCoreObject()
local closestBank = nil
local inRange
local requiredItemsShowed = false
local copsCalled = false
local PlayerJob = {}
local refreshed = false
currentThermiteGate = 0
CurrentCops = 0

-- Handlers

local function ResetBankDoors()
    for k, v in pairs(Config.SmallBanks) do
        local object = GetClosestObjectOfType(Config.SmallBanks[k]["coords"]["x"], Config.SmallBanks[k]["coords"]["y"], Config.SmallBanks[k]["coords"]["z"], 5.0, Config.SmallBanks[k]["object"], false, false, false)
        if not Config.SmallBanks[k]["isOpened"] then
            SetEntityHeading(object, Config.SmallBanks[k]["heading"].closed)
        else
            SetEntityHeading(object, Config.SmallBanks[k]["heading"].open)
        end
    end
    if not Config.BigBanks["paleto"]["isOpened"] then
        local paletoObject = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)
        SetEntityHeading(paletoObject, Config.BigBanks["paleto"]["heading"].closed)
    else
        local paletoObject = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)
        SetEntityHeading(paletoObject, Config.BigBanks["paleto"]["heading"].open)
    end

    if not Config.BigBanks["pacific"]["isOpened"] then
        local pacificObject = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
        SetEntityHeading(pacificObject, Config.BigBanks["pacific"]["heading"].closed)
    else
        local pacificObject = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
        SetEntityHeading(pacificObject, Config.BigBanks["pacific"]["heading"].open)
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        ResetBankDoors()
    end
end)

RegisterNetEvent('DenaliFW:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = true
end)

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('DenaliFW:Client:OnPlayerLoaded', function()
    PlayerJob = DenaliFW.Functions.GetPlayerData().job
    DenaliFW.Functions.TriggerCallback('denalifw-bankrobbery:server:GetConfig', function(config)
        Config = config
    end)
    onDuty = true
    ResetBankDoors()
end)

-- Functions

function DrawText3Ds(x, y, z, text) -- Globally used
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function OpenPaletoDoor()
    TriggerServerEvent('denalifw-doorlock:server:updateState', 85, false)
    local object = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)
    local timeOut = 10
    local entHeading = Config.BigBanks["paleto"]["heading"].closed

    if object ~= 0 then
        SetEntityHeading(object, Config.BigBanks["paleto"]["heading"].open)
    end
end

local function OpenPacificDoor()
    local object = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
    local timeOut = 10
    local entHeading = Config.BigBanks["pacific"]["heading"].closed

    if object ~= 0 then
        CreateThread(function()
            while true do

                if entHeading > Config.BigBanks["pacific"]["heading"].open then
                    SetEntityHeading(object, entHeading - 10)
                    entHeading = entHeading - 0.5
                else
                    break
                end

                Wait(10)
            end
        end)
    end
end

local function OnHackDone(success)
    if success then
        TriggerEvent('mhacking:hide')
        TriggerServerEvent('denalifw-bankrobbery:server:setBankState', closestBank, true)
    else
		TriggerEvent('mhacking:hide')
	end
end

local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function OpenBankDoor(bankId)
    local object = GetClosestObjectOfType(Config.SmallBanks[bankId]["coords"]["x"], Config.SmallBanks[bankId]["coords"]["y"], Config.SmallBanks[bankId]["coords"]["z"], 5.0, Config.SmallBanks[bankId]["object"], false, false, false)
    local timeOut = 10
    local entHeading = Config.SmallBanks[bankId]["heading"].closed
    if object ~= 0 then
        CreateThread(function()
            while true do

                if entHeading ~= Config.SmallBanks[bankId]["heading"].open then
                    SetEntityHeading(object, entHeading - 10)
                    entHeading = entHeading - 0.5
                else
                    break
                end

                Wait(10)
            end
        end)
    end
end

function IsWearingHandshoes() -- Globally Used
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == `mp_m_freemode_01` then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

function openLocker(bankId, lockerId) -- Globally Used
    local pos = GetEntityCoords(PlayerPedId())
    if math.random(1, 100) <= 65 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    TriggerServerEvent('denalifw-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', true)
    if bankId == "paleto" then
        DenaliFW.Functions.TriggerCallback('DenaliFW:HasItem', function(hasItem)
            if hasItem then
                loadAnimDict("anim@heists@fleeca_bank@drilling")
                TaskPlayAnim(PlayerPedId(), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
                local pos = GetEntityCoords(PlayerPedId(), true)
                local DrillObject = CreateObject(`hei_prop_heist_drill`, pos.x, pos.y, pos.z, true, true, true)
                AttachEntityToEntity(DrillObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
                IsDrilling = true
                DenaliFW.Functions.Progressbar("open_locker_drill", "Breaking open the safe ..", math.random(18000, 30000), false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                    DetachEntity(DrillObject, true, true)
                    DeleteObject(DrillObject)
                    TriggerServerEvent('denalifw-bankrobbery:server:setLockerState', bankId, lockerId, 'isOpened', true)
                    TriggerServerEvent('denalifw-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                    TriggerServerEvent('denalifw-bankrobbery:server:recieveItem', 'paleto')
                    DenaliFW.Functions.Notify("Successful!", "success")
                    IsDrilling = false
                end, function() -- Cancel
                    StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                    TriggerServerEvent('denalifw-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                    DetachEntity(DrillObject, true, true)
                    DeleteObject(DrillObject)
                    DenaliFW.Functions.Notify("Canceled..", "error")
                    IsDrilling = false
                end)
                CreateThread(function()
                    while IsDrilling do
                        TriggerServerEvent('hud:server:GainStress', math.random(4, 8))
                        Wait(10000)
                    end
                end)
            else
                DenaliFW.Functions.Notify("Looks like the safe lock is too strong ..", "error")
                TriggerServerEvent('denalifw-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
            end
        end, "drill")
    elseif bankId == "pacific" then
        DenaliFW.Functions.TriggerCallback('DenaliFW:HasItem', function(hasItem)
            if hasItem then
                loadAnimDict("anim@heists@fleeca_bank@drilling")
                TaskPlayAnim(PlayerPedId(), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
                local pos = GetEntityCoords(PlayerPedId(), true)
                local DrillObject = CreateObject(`hei_prop_heist_drill`, pos.x, pos.y, pos.z, true, true, true)
                AttachEntityToEntity(DrillObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
                IsDrilling = true
                DenaliFW.Functions.Progressbar("open_locker_drill", "Breaking open the safe ..", math.random(18000, 30000), false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                    DetachEntity(DrillObject, true, true)
                    DeleteObject(DrillObject)

                    TriggerServerEvent('denalifw-bankrobbery:server:setLockerState', bankId, lockerId, 'isOpened', true)
                    TriggerServerEvent('denalifw-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                    TriggerServerEvent('denalifw-bankrobbery:server:recieveItem', 'pacific')
                    DenaliFW.Functions.Notify("Successful!", "success")
                    IsDrilling = false
                end, function() -- Cancel
                    StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                    TriggerServerEvent('denalifw-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                    DetachEntity(DrillObject, true, true)
                    DeleteObject(DrillObject)
                    DenaliFW.Functions.Notify("Canceled..", "error")
                    IsDrilling = false
                end)
                CreateThread(function()
                    while IsDrilling do
                        TriggerServerEvent('hud:server:GainStress', math.random(4, 8))
                        Wait(10000)
                    end
                end)
            else
                DenaliFW.Functions.Notify("Looks like the safe lock is too strong ..", "error")
                TriggerServerEvent('denalifw-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
            end
        end, "drill")
    else
        IsDrilling = true
        DenaliFW.Functions.Progressbar("open_locker", "Breaking open the safe ..", math.random(27000, 37000), false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@gangops@facility@servers@",
            anim = "hotwire",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
            TriggerServerEvent('denalifw-bankrobbery:server:setLockerState', bankId, lockerId, 'isOpened', true)
            TriggerServerEvent('denalifw-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
            TriggerServerEvent('denalifw-bankrobbery:server:recieveItem', 'small')
            DenaliFW.Functions.Notify("Successful!", "success")
            IsDrilling = false
        end, function() -- Cancel
            StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
            TriggerServerEvent('denalifw-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
            DenaliFW.Functions.Notify("Canceled..", "error")
            IsDrilling = false
        end)
        CreateThread(function()
            while IsDrilling do
                TriggerServerEvent('hud:server:GainStress', math.random(4, 8))
                Wait(10000)
            end
        end)
    end
end

-- Events

RegisterNetEvent('electronickit:UseElectronickit', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    if closestBank ~= nil then
        DenaliFW.Functions.TriggerCallback('denalifw-bankrobbery:server:isRobberyActive', function(isBusy)
            if not isBusy then
                if closestBank ~= nil then
                    local dist = #(pos - Config.SmallBanks[closestBank]["coords"])
                    if dist < 1.5 then
                        if CurrentCops >= Config.MinimumFleecaPolice then
                            if not Config.SmallBanks[closestBank]["isOpened"] then
                                DenaliFW.Functions.TriggerCallback('DenaliFW:HasItem', function(result)
                                    if result then
                                        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                                        DenaliFW.Functions.Progressbar("hack_gate", "Connecting the hacking device ..", math.random(5000, 10000), false, true, {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        }, {
                                            animDict = "anim@gangops@facility@servers@",
                                            anim = "hotwire",
                                            flags = 16,
                                        }, {}, {}, function() -- Done
                                            StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)

                                            TriggerServerEvent("DenaliFW:Server:RemoveItem", "electronickit", 1)
                                            TriggerEvent('inventory:client:ItemBox', DenaliFW.Shared.Items["electronickit"], "remove")
                                            TriggerServerEvent("DenaliFW:Server:RemoveItem", "trojan_usb", 1)
                                            TriggerEvent('inventory:client:ItemBox', DenaliFW.Shared.Items["trojan_usb"], "remove")

                                            TriggerEvent("mhacking:show")
                                            TriggerEvent("mhacking:start", math.random(6, 7), math.random(12, 15), OnHackDone)
                                            if not copsCalled then
                                                local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                                                local street1 = GetStreetNameFromHashKey(s1)
                                                local street2 = GetStreetNameFromHashKey(s2)
                                                local streetLabel = street1
                                                if street2 ~= nil then
                                                    streetLabel = streetLabel .. " " .. street2
                                                end
                                                if Config.SmallBanks[closestBank]["alarm"] then
                                                    TriggerServerEvent("denalifw-bankrobbery:server:callCops", "small", closestBank, streetLabel, pos)
                                                    copsCalled = true
                                                end
                                            end
                                        end, function() -- Cancel
                                            StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                            DenaliFW.Functions.Notify("Canceled..", "error")
                                        end)
                                    else
                                        DenaliFW.Functions.Notify("You're missing an item ..", "error")
                                    end
                                end, "trojan_usb")
                            else
                                DenaliFW.Functions.Notify("Looks like the bank is already open ..", "error")
                            end
                        else
                            DenaliFW.Functions.Notify('Minimum Of '..Config.MinimumFleecaPolice..' Police Needed', "error")
                        end
                    end
                end
            else
                DenaliFW.Functions.Notify("The security lock is active, opening the door is currently not possible.", "error", 5500)
            end
        end)
    end
end)

RegisterNetEvent('denalifw-bankrobbery:client:setBankState', function(bankId, state)
    if bankId == "paleto" then
        Config.BigBanks["paleto"]["isOpened"] = state
        if state then
            OpenPaletoDoor()
        end
    elseif bankId == "pacific" then
        Config.BigBanks["pacific"]["isOpened"] = state
        if state then
            OpenPacificDoor()
        end
    else
        Config.SmallBanks[bankId]["isOpened"] = state
        if state then
            OpenBankDoor(bankId)
        end
    end
end)

RegisterNetEvent('denalifw-bankrobbery:client:enableAllBankSecurity', function()
    for k, v in pairs(Config.SmallBanks) do
        Config.SmallBanks[k]["alarm"] = true
    end
end)

RegisterNetEvent('denalifw-bankrobbery:client:disableAllBankSecurity', function()
    for k, v in pairs(Config.SmallBanks) do
        Config.SmallBanks[k]["alarm"] = false
    end
end)

RegisterNetEvent('denalifw-bankrobbery:client:BankSecurity', function(key, status)
    Config.SmallBanks[key]["alarm"] = status
end)

RegisterNetEvent('denalifw-bankrobbery:client:setLockerState', function(bankId, lockerId, state, bool)
    if bankId == "paleto" then
        Config.BigBanks["paleto"]["lockers"][lockerId][state] = bool
    elseif bankId == "pacific" then
        Config.BigBanks["pacific"]["lockers"][lockerId][state] = bool
    else
        Config.SmallBanks[bankId]["lockers"][lockerId][state] = bool
    end
end)

RegisterNetEvent('denalifw-bankrobbery:client:ResetFleecaLockers', function(BankId)
    Config.SmallBanks[BankId]["isOpened"] = false
    for k,_ in pairs(Config.SmallBanks[BankId]["lockers"]) do
        Config.SmallBanks[BankId]["lockers"][k]["isOpened"] = false
        Config.SmallBanks[BankId]["lockers"][k]["isBusy"] = false
    end
end)

RegisterNetEvent('denalifw-bankrobbery:client:robberyCall', function(type, key, streetLabel, coords)
    if PlayerJob.name == "police" and onDuty then
        local cameraId = 4
        local bank = "Fleeca"
        if type == "small" then
            cameraId = Config.SmallBanks[key]["camId"]
            bank = "Fleeca"
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            TriggerEvent('denalifw-policealerts:client:AddPoliceAlert', {
                timeOut = 10000,
                alertTitle = "Fleeca bank robbery attempt",
                coords = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                },
                details = {
                    [1] = {
                        icon = '<i class="fas fa-university"></i>',
                        detail = bank,
                    },
                    [2] = {
                        icon = '<i class="fas fa-video"></i>',
                        detail = cameraId,
                    },
                    [3] = {
                        icon = '<i class="fas fa-globe-europe"></i>',
                        detail = streetLabel,
                    },
                },
                callSign = DenaliFW.Functions.GetPlayerData().metadata["callsign"],
            })
        elseif type == "paleto" then
            cameraId = Config.BigBanks["paleto"]["camId"]
            bank = "Blaine County Savings"
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            Wait(100)
            PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
            Wait(100)
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            Wait(100)
            PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
            TriggerEvent('denalifw-policealerts:client:AddPoliceAlert', {
                timeOut = 10000,
                alertTitle = "Blain County Savings bank robbery attempt",
                coords = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                },
                details = {
                    [1] = {
                        icon = '<i class="fas fa-university"></i>',
                        detail = bank,
                    },
                    [2] = {
                        icon = '<i class="fas fa-video"></i>',
                        detail = cameraId,
                    },
                },
                callSign = DenaliFW.Functions.GetPlayerData().metadata["callsign"],
            })
        elseif type == "pacific" then
            bank = "Pacific Standard Bank"
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            Wait(100)
            PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
            Wait(100)
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            Wait(100)
            PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
            TriggerEvent('denalifw-policealerts:client:AddPoliceAlert', {
                timeOut = 10000,
                alertTitle = "Pacific Standard Bank robbery attempt",
                coords = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                },
                details = {
                    [1] = {
                        icon = '<i class="fas fa-university"></i>',
                        detail = bank,
                    },
                    [2] = {
                        icon = '<i class="fas fa-video"></i>',
                        detail = "1 | 2 | 3",
                    },
                    [3] = {
                        icon = '<i class="fas fa-globe-europe"></i>',
                        detail = "Alta St",
                    },
                },
                callSign = DenaliFW.Functions.GetPlayerData().metadata["callsign"],
            })
        end
        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 487)
        SetBlipColour(blip, 4)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 1.2)
        SetBlipFlashes(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("10-90: Bank Robbery")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)

-- Threads

CreateThread(function()
    while true do
        Wait(1000 * 60 * 5)
        if copsCalled then
            copsCalled = false
        end
    end
end)

CreateThread(function()
    Wait(500)
    if DenaliFW.Functions.GetPlayerData() ~= nil then
        PlayerJob = DenaliFW.Functions.GetPlayerData().job
        onDuty = true
    end
end)

RegisterNetEvent('DenaliFW:Client:SetDuty', function(duty)
    onDuty = duty
end)

CreateThread(function()
    while true do
        Wait(1000)
        if inRange then
            if not refreshed then
                ResetBankDoors()
                refreshed = true
            end
        else
            refreshed = false
        end
    end
end)

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist

        if DenaliFW ~= nil then
            inRange = false

            for k, v in pairs(Config.SmallBanks) do
                dist = #(pos - Config.SmallBanks[k]["coords"])
                if dist < 15 then
                    closestBank = k
                    inRange = true
                end
            end

            if not inRange then
                Wait(2000)
                closestBank = nil
            end
        end

        Wait(3)
    end
end)

CreateThread(function()
    Wait(2000)
    local requiredItems = {
        [1] = {name = DenaliFW.Shared.Items["electronickit"]["name"], image = DenaliFW.Shared.Items["electronickit"]["image"]},
        [2] = {name = DenaliFW.Shared.Items["trojan_usb"]["name"], image = DenaliFW.Shared.Items["trojan_usb"]["image"]},
    }
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        if DenaliFW ~= nil then
            if closestBank ~= nil then
                if not Config.SmallBanks[closestBank]["isOpened"] then
                    local dist = #(pos - Config.SmallBanks[closestBank]["coords"])
                    if dist < 1 then
                        if not requiredItemsShowed then
                            requiredItemsShowed = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                    else
                        if requiredItemsShowed then
                            requiredItemsShowed = false
                            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                        end
                    end
                end
                if Config.SmallBanks[closestBank]["isOpened"] then
                    for k, v in pairs(Config.SmallBanks[closestBank]["lockers"]) do
                        local lockerDist = #(pos - Config.SmallBanks[closestBank]["lockers"][k]["coords"])
                        if not Config.SmallBanks[closestBank]["lockers"][k]["isBusy"] then
                            if not Config.SmallBanks[closestBank]["lockers"][k]["isOpened"] then
                                if lockerDist < 5 then
                                    DrawMarker(2, Config.SmallBanks[closestBank]["lockers"][k]["coords"].x, Config.SmallBanks[closestBank]["lockers"][k]["coords"].y, Config.SmallBanks[closestBank]["lockers"][k]["coords"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                                    if lockerDist < 0.5 then
                                        DrawText3Ds(Config.SmallBanks[closestBank]["lockers"][k]["coords"].x, Config.SmallBanks[closestBank]["lockers"][k]["coords"].y, Config.SmallBanks[closestBank]["lockers"][k]["coords"].z + 0.3, '[E] Break open the safe')
                                        if IsControlJustPressed(0, 38) then
                                            if CurrentCops >= Config.MinimumFleecaPolice then
                                                openLocker(closestBank, k)
                                            else
                                                DenaliFW.Functions.Notify('Minimum Of '..Config.MinimumFleecaPolice..' Police Needed', "error")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            else
                Wait(2500)
            end
        end

        Wait(1)
    end
end)