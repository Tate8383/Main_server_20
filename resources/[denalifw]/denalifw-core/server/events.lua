-- Event Handler

AddEventHandler('playerDropped', function()
    local src = source
    if DenaliFW.Players[src] then
        local Player = DenaliFW.Players[src]
        TriggerEvent('denalifw-log:server:CreateLog', 'joinleave', 'Dropped', 'red', '**' .. GetPlayerName(src) .. '** (' .. Player.PlayerData.license .. ') left..')
        Player.Functions.Save()
        _G.Player_Buckets[Player.PlayerData.license] = nil
        DenaliFW.Players[src] = nil
    end
end)

AddEventHandler('chatMessage', function(source, n, message)
    local src = source
    if string.sub(message, 1, 1) == '/' then
        local args = DenaliFW.Shared.SplitStr(message, ' ')
        local command = string.gsub(args[1]:lower(), '/', '')
        CancelEvent()
        if DenaliFW.Commands.List[command] then
            local Player = DenaliFW.Functions.GetPlayer(src)
            if Player then
                local isGod = DenaliFW.Functions.HasPermission(src, 'god')
                local hasPerm = DenaliFW.Functions.HasPermission(src, DenaliFW.Commands.List[command].permission)
                local isPrincipal = IsPlayerAceAllowed(src, 'command')
                table.remove(args, 1)
                if isGod or hasPerm or isPrincipal then
                    if (DenaliFW.Commands.List[command].argsrequired and #DenaliFW.Commands.List[command].arguments ~= 0 and args[#DenaliFW.Commands.List[command].arguments] == nil) then
                        TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.missing_args2'), 'error')
                    else
                        DenaliFW.Commands.List[command].callback(src, args)
                    end
                else
                    TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.no_access'), 'error')
                end
            end
        end
    end
end)

-- Player Connecting

local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local license
    local identifiers = GetPlayerIdentifiers(player)
    deferrals.defer()

    -- mandatory wait!
    Wait(0)

    deferrals.update(string.format('Hello %s. Validating Your Rockstar License', name))

    for _, v in pairs(identifiers) do
        if string.find(v, 'license') then
            license = v
            break
        end
    end

    -- mandatory wait!
    Wait(2500)

    deferrals.update(string.format('Hello %s. We are checking if you are banned.', name))

    local isBanned, Reason = DenaliFW.Functions.IsPlayerBanned(player)
    local isLicenseAlreadyInUse = DenaliFW.Functions.IsLicenseInUse(license)

    Wait(2500)

    deferrals.update(string.format('Welcome %s to {Server Name}.', name))

    if not license then
        deferrals.done('No Valid Rockstar License Found')
    elseif isBanned then
        deferrals.done(Reason)
    elseif isLicenseAlreadyInUse then
        deferrals.done('Duplicate Rockstar License Found')
    else
        deferrals.done()
        Wait(1000)
        TriggerEvent('connectqueue:playerConnect', name, setKickReason, deferrals)
    end
    --Add any additional defferals you may need!
end

AddEventHandler('playerConnecting', OnPlayerConnecting)

-- Open & Close Server (prevents players from joining)

RegisterNetEvent('DenaliFW:server:CloseServer', function(reason)
    local src = source
    if DenaliFW.Functions.HasPermission(src, 'admin') or DenaliFW.Functions.HasPermission(src, 'god') then
        local reason = reason or 'No reason specified'
        DenaliFW.Config.Server.closed = true
        DenaliFW.Config.Server.closedReason = reason
    else
        DenaliFW.Functions.Kick(src, 'You don\'t have permissions for this..', nil, nil)
    end
end)

RegisterNetEvent('DenaliFW:server:OpenServer', function()
    local src = source
    if DenaliFW.Functions.HasPermission(src, 'admin') or DenaliFW.Functions.HasPermission(src, 'god') then
        DenaliFW.Config.Server.closed = false
    else
        DenaliFW.Functions.Kick(src, 'You don\'t have permissions for this..', nil, nil)
    end
end)

-- Callbacks

RegisterNetEvent('DenaliFW:Server:TriggerCallback', function(name, ...)
    local src = source
    DenaliFW.Functions.TriggerCallback(name, src, function(...)
        TriggerClientEvent('DenaliFW:Client:TriggerCallback', src, name, ...)
    end, ...)
end)

-- Player

RegisterNetEvent('DenaliFW:UpdatePlayer', function()
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    if Player then
        local newHunger = Player.PlayerData.metadata['hunger'] - DenaliFW.Config.Player.HungerRate
        local newThirst = Player.PlayerData.metadata['thirst'] - DenaliFW.Config.Player.ThirstRate
        if newHunger <= 0 then
            newHunger = 0
        end
        if newThirst <= 0 then
            newThirst = 0
        end
        Player.Functions.SetMetaData('thirst', newThirst)
        Player.Functions.SetMetaData('hunger', newHunger)
        TriggerClientEvent('hud:client:UpdateNeeds', src, newHunger, newThirst)
        Player.Functions.Save()
    end
end)

RegisterNetEvent('DenaliFW:Server:SetMetaData', function(meta, data)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    if meta == 'hunger' or meta == 'thirst' then
        if data > 100 then
            data = 100
        end
    end
    if Player then
        Player.Functions.SetMetaData(meta, data)
    end
    TriggerClientEvent('hud:client:UpdateNeeds', src, Player.PlayerData.metadata['hunger'], Player.PlayerData.metadata['thirst'])
end)

RegisterNetEvent('DenaliFW:ToggleDuty', function()
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.onduty then
        Player.Functions.SetJobDuty(false)
        TriggerClientEvent('DenaliFW:Notify', src, Lang:t('info.off_duty'))
    else
        Player.Functions.SetJobDuty(true)
        TriggerClientEvent('DenaliFW:Notify', src, Lang:t('info.on_duty'))
    end
    TriggerClientEvent('DenaliFW:Client:SetDuty', src, Player.PlayerData.job.onduty)
end)

-- Items

RegisterNetEvent('DenaliFW:Server:UseItem', function(item)
    local src = source
    if item and item.amount > 0 then
        if DenaliFW.Functions.CanUseItem(item.name) then
            DenaliFW.Functions.UseItem(src, item)
        end
    end
end)

RegisterNetEvent('DenaliFW:Server:RemoveItem', function(itemName, amount, slot)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(itemName, amount, slot)
end)

RegisterNetEvent('DenaliFW:Server:AddItem', function(itemName, amount, slot, info)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    Player.Functions.AddItem(itemName, amount, slot, info)
end)

-- Non-Chat Command Calling (ex: denalifw-adminmenu)

RegisterNetEvent('DenaliFW:CallCommand', function(command, args)
    local src = source
    if DenaliFW.Commands.List[command] then
        local Player = DenaliFW.Functions.GetPlayer(src)
        if Player then
            local isGod = DenaliFW.Functions.HasPermission(src, 'god')
            local hasPerm = DenaliFW.Functions.HasPermission(src, DenaliFW.Commands.List[command].permission)
            local isPrincipal = IsPlayerAceAllowed(src, 'command')
            if (DenaliFW.Commands.List[command].permission == Player.PlayerData.job.name) or isGod or hasPerm or isPrincipal then
                if (DenaliFW.Commands.List[command].argsrequired and #DenaliFW.Commands.List[command].arguments ~= 0 and args[#DenaliFW.Commands.List[command].arguments] == nil) then
                    TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.missing_args2'), 'error')
                else
                    DenaliFW.Commands.List[command].callback(src, args)
                end
            else
                TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.no_access'), 'error')
            end
        end
    end
end)

-- Has Item Callback (can also use client function - DenaliFW.Functions.HasItem(item))

DenaliFW.Functions.CreateCallback('DenaliFW:HasItem', function(source, cb, items, amount)
    local src = source
    local retval = false
    local Player = DenaliFW.Functions.GetPlayer(src)
    if Player then
        if type(items) == 'table' then
            local count = 0
            local finalcount = 0
            for k, v in pairs(items) do
                if type(k) == 'string' then
                    finalcount = 0
                    for i, _ in pairs(items) do
                        if i then
                            finalcount = finalcount + 1
                        end
                    end
                    local item = Player.Functions.GetItemByName(k)
                    if item then
                        if item.amount >= v then
                            count = count + 1
                            if count == finalcount then
                                retval = true
                            end
                        end
                    end
                else
                    finalcount = #items
                    local item = Player.Functions.GetItemByName(v)
                    if item then
                        if amount then
                            if item.amount >= amount then
                                count = count + 1
                                if count == finalcount then
                                    retval = true
                                end
                            end
                        else
                            count = count + 1
                            if count == finalcount then
                                retval = true
                            end
                        end
                    end
                end
            end
        else
            local item = Player.Functions.GetItemByName(items)
            if item then
                if amount then
                    if item.amount >= amount then
                        retval = true
                    end
                else
                    retval = true
                end
            end
        end
    end
    cb(retval)
end)
