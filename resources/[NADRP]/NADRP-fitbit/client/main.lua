local NADRP = exports['NADRP-core']:GetCoreObject()
local inWatch = false

-- Functions

local function openWatch()
    SendNUIMessage({
        action = "openWatch",
        watchData = {}
    })
    SetNuiFocus(true, true)
    inWatch = true
end

local function closeWatch()
    SetNuiFocus(false, false)
end

local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- Events

RegisterNUICallback('close', function()
    closeWatch()
end)

RegisterNetEvent('NADRP-fitbit:use', function()
  openWatch()
end)

-- NUI Callbacks

RegisterNUICallback('setFoodWarning', function(data)
    local foodValue = tonumber(data.value)

    TriggerServerEvent('NADRP-fitbit:server:setValue', 'food', foodValue)

    NADRP.Functions.Notify('Fitbit: Hunger warning set to '..foodValue..'%')
end)

RegisterNUICallback('setThirstWarning', function(data)
    local thirstValue = tonumber(data.value)

    TriggerServerEvent('NADRP-fitbit:server:setValue', 'thirst', thirstValue)

    NADRP.Functions.Notify('Fitbit: Thirst warning set to '..thirstValue..'%')
end)

-- Threads

CreateThread(function()
    while true do
        Wait(5 * 60 * 1000)
        if LocalPlayer.state.isLoggedIn then
            NADRP.Functions.TriggerCallback('NADRP-fitbit:server:HasFitbit', function(hasItem)
                if hasItem then
                    local PlayerData = NADRP.Functions.GetPlayerData()
                    if PlayerData.metadata["fitbit"].food ~= nil then
                        if PlayerData.metadata["hunger"] < PlayerData.metadata["fitbit"].food then
                            TriggerEvent("chatMessage", "FITBIT ", "warning", "Your hunger is "..round(PlayerData.metadata["hunger"], 2).."%")
                            PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
                        end
                    end
                    if PlayerData.metadata["fitbit"].thirst ~= nil then
                        if PlayerData.metadata["thirst"] < PlayerData.metadata["fitbit"].thirst  then
                            TriggerEvent("chatMessage", "FITBIT ", "warning", "Your thirst is "..round(PlayerData.metadata["thirst"], 2).."%")
                            PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
                        end
                    end
                end
            end, "fitbit")
        end
    end
end)
