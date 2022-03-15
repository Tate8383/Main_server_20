local DenaliFW = exports['denalifw-core']:GetCoreObject()

local Races = {}

RegisterNetEvent('denalifw-streetraces:NewRace', function(RaceTable)
    local src = source
    local RaceId = math.random(1000, 9999)
    local xPlayer = DenaliFW.Functions.GetPlayer(src)
    if xPlayer.Functions.RemoveMoney('cash', RaceTable.amount, "streetrace-created") then
        Races[RaceId] = RaceTable
        Races[RaceId].creator = DenaliFW.Functions.GetIdentifier(src, 'license')
        Races[RaceId].joined[#Races[RaceId].joined+1] = DenaliFW.Functions.GetIdentifier(src, 'license')
        TriggerClientEvent('denalifw-streetraces:SetRace', -1, Races)
        TriggerClientEvent('denalifw-streetraces:SetRaceId', src, RaceId)
        TriggerClientEvent('DenaliFW:Notify', src, "You joind the race for €"..Races[RaceId].amount..",-", 'success')
    end
end)

RegisterNetEvent('denalifw-streetraces:RaceWon', function(RaceId)
    local src = source
    local xPlayer = DenaliFW.Functions.GetPlayer(src)
    xPlayer.Functions.AddMoney('cash', Races[RaceId].pot, "race-won")
    TriggerClientEvent('DenaliFW:Notify', src, "You won the race and €"..Races[RaceId].pot..",- recieved", 'success')
    TriggerClientEvent('denalifw-streetraces:SetRace', -1, Races)
    TriggerClientEvent('denalifw-streetraces:RaceDone', -1, RaceId, GetPlayerName(src))
end)

RegisterNetEvent('denalifw-streetraces:JoinRace', function(RaceId)
    local src = source
    local xPlayer = DenaliFW.Functions.GetPlayer(src)
    local zPlayer = DenaliFW.Functions.GetPlayer(Races[RaceId].creator)
    if zPlayer ~= nil then
        if xPlayer.PlayerData.money.cash >= Races[RaceId].amount then
            Races[RaceId].pot = Races[RaceId].pot + Races[RaceId].amount
            Races[RaceId].joined[#Races[RaceId].joined+1] = DenaliFW.Functions.GetIdentifier(src, 'license')
            if xPlayer.Functions.RemoveMoney('cash', Races[RaceId].amount, "streetrace-joined") then
                TriggerClientEvent('denalifw-streetraces:SetRace', -1, Races)
                TriggerClientEvent('denalifw-streetraces:SetRaceId', src, RaceId)
                TriggerClientEvent('DenaliFW:Notify', zPlayer.PlayerData.source, GetPlayerName(src).." Joined the race", 'primary')
            end
        else
            TriggerClientEvent('DenaliFW:Notify', src, "You dont have enough cash", 'error')
        end
    else
        TriggerClientEvent('DenaliFW:Notify', src, "The person wo made the race is offline!", 'error')
        Races[RaceId] = {}
    end
end)

DenaliFW.Commands.Add("createrace", "Start A Street Race", {{name="amount", help="The Stake Amount For The Race."}}, false, function(source, args)
    local src = source
    local amount = tonumber(args[1])
    if GetJoinedRace(DenaliFW.Functions.GetIdentifier(src, 'license')) == 0 then
        TriggerClientEvent('denalifw-streetraces:CreateRace', src, amount)
    else
        TriggerClientEvent('DenaliFW:Notify', src, "You Are Already In A Race", 'error')
    end
end)

DenaliFW.Commands.Add("stoprace", "Stop The Race You Created", {}, false, function(source, args)
    local src = source
    CancelRace(src)
end)

DenaliFW.Commands.Add("quitrace", "Get Out Of A Race. (You Will NOT Get Your Money Back!)", {}, false, function(source, args)
    local src = source
    local RaceId = GetJoinedRace(DenaliFW.Functions.GetIdentifier(src, 'license'))
    if RaceId ~= 0 then
        if GetCreatedRace(DenaliFW.Functions.GetIdentifier(src, 'license')) ~= RaceId then
            RemoveFromRace(DenaliFW.Functions.GetIdentifier(src, 'license'))
            TriggerClientEvent('DenaliFW:Notify', src, "You Have Stepped Out Of The Race! And You Lost Your Money", 'error')
        else
            TriggerClientEvent('DenaliFW:Notify', src, "/stoprace To Stop The Race", 'error')
        end
    else
        TriggerClientEvent('DenaliFW:Notify', src, "You Are Not In A Race ", 'error')
    end
end)

DenaliFW.Commands.Add("startrace", "Start The Race", {}, false, function(source, args)
    local src = source
    local RaceId = GetCreatedRace(DenaliFW.Functions.GetIdentifier(src, 'license'))

    if RaceId ~= 0 then

        Races[RaceId].started = true
        TriggerClientEvent('denalifw-streetraces:SetRace', -1, Races)
        TriggerClientEvent("denalifw-streetraces:StartRace", -1, RaceId)
    else
        TriggerClientEvent('DenaliFW:Notify', src, "You Have Not Started A Race", 'error')

    end
end)

function CancelRace(source)
    local RaceId = GetCreatedRace(DenaliFW.Functions.GetIdentifier(source, 'license'))
    local Player = DenaliFW.Functions.GetPlayer(source)

    if RaceId ~= 0 then
        for key, race in pairs(Races) do
            if Races[key] ~= nil and Races[key].creator == Player.PlayerData.license then
                if not Races[key].started then
                    for _, iden in pairs(Races[key].joined) do
                        local xdPlayer = DenaliFW.Functions.GetPlayer(iden)
                            xdPlayer.Functions.AddMoney('cash', Races[key].amount, "race-cancelled")
                            TriggerClientEvent('DenaliFW:Notify', xdPlayer.PlayerData.source, "Race Has Stopped, You Got Back $"..Races[key].amount.."", 'error')
                            TriggerClientEvent('denalifw-streetraces:StopRace', xdPlayer.PlayerData.source)
                            RemoveFromRace(iden)
                    end
                else
                    TriggerClientEvent('DenaliFW:Notify', Player.PlayerData.source, "The Race Has Already Started", 'error')
                end
                TriggerClientEvent('DenaliFW:Notify', source, "Race Stopped!", 'error')
                Races[key] = nil
            end
        end
        TriggerClientEvent('denalifw-streetraces:SetRace', -1, Races)
    else
        TriggerClientEvent('DenaliFW:Notify', source, "You Have Not Started A Race!", 'error')
    end
end

function RemoveFromRace(identifier)
    for key, race in pairs(Races) do
        if Races[key] ~= nil and not Races[key].started then
            for i, iden in pairs(Races[key].joined) do
                if iden == identifier then
                    table.remove(Races[key].joined, i)
                end
            end
        end
    end
end

function GetJoinedRace(identifier)
    for key, race in pairs(Races) do
        if Races[key] ~= nil and not Races[key].started then
            for _, iden in pairs(Races[key].joined) do
                if iden == identifier then
                    return key
                end
            end
        end
    end
    return 0
end

function GetCreatedRace(identifier)
    for key, race in pairs(Races) do
        if Races[key] ~= nil and Races[key].creator == identifier and not Races[key].started then
            return key
        end
    end
    return 0
end
