-- Event Handler

AddEventHandler('playerDropped', function()
    local src = source
    if NADRP.Players[src] then
        local Player = NADRP.Players[src]
        TriggerEvent('NADRP-log:server:CreateLog', 'joinleave', 'Dropped', 'red', '**' .. GetPlayerName(src) .. '** (' .. Player.PlayerData.license .. ') left..')
        Player.Functions.Save()
        _G.Player_Buckets[Player.PlayerData.license] = nil
        NADRP.Players[src] = nil
    end
end)

AddEventHandler('chatMessage', function(source, n, message)
    local src = source
    if string.sub(message, 1, 1) == '/' then
        local args = NADRP.Shared.SplitStr(message, ' ')
        local command = string.gsub(args[1]:lower(), '/', '')
        CancelEvent()
        if NADRP.Commands.List[command] then
            local Player = NADRP.Functions.GetPlayer(src)
            if Player then
                local isGod = NADRP.Functions.HasPermission(src, 'god')
                local hasPerm = NADRP.Functions.HasPermission(src, NADRP.Commands.List[command].permission)
                local isPrincipal = IsPlayerAceAllowed(src, 'command')
                table.remove(args, 1)
                if isGod or hasPerm or isPrincipal then
                    if (NADRP.Commands.List[command].argsrequired and #NADRP.Commands.List[command].arguments ~= 0 and args[#NADRP.Commands.List[command].arguments] == nil) then
                        TriggerClientEvent('NADRP:Notify', src, Lang:t('error.missing_args2'), 'error')
                    else
                        NADRP.Commands.List[command].callback(src, args)
                    end
                else
                    TriggerClientEvent('NADRP:Notify', src, Lang:t('error.no_access'), 'error')
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

    local isBanned, Reason = NADRP.Functions.IsPlayerBanned(player)
    local isLicenseAlreadyInUse = NADRP.Functions.IsLicenseInUse(license)

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

RegisterNetEvent('NADRP:server:CloseServer', function(reason)
    local src = source
    if NADRP.Functions.HasPermission(src, 'admin') or NADRP.Functions.HasPermission(src, 'god') then
        local reason = reason or 'No reason specified'
        NADRP.Config.Server.closed = true
        NADRP.Config.Server.closedReason = reason
    else
        NADRP.Functions.Kick(src, 'You don\'t have permissions for this..', nil, nil)
    end
end)

RegisterNetEvent('NADRP:server:OpenServer', function()
    local src = source
    if NADRP.Functions.HasPermission(src, 'admin') or NADRP.Functions.HasPermission(src, 'god') then
        NADRP.Config.Server.closed = false
    else
        NADRP.Functions.Kick(src, 'You don\'t have permissions for this..', nil, nil)
    end
end)

-- Callbacks

RegisterNetEvent('NADRP:Server:TriggerCallback', function(name, ...)
    local src = source
    NADRP.Functions.TriggerCallback(name, src, function(...)
        TriggerClientEvent('NADRP:Client:TriggerCallback', src, name, ...)
    end, ...)
end)

-- Player

RegisterNetEvent('NADRP:UpdatePlayer', function()
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
    if Player then
        local newHunger = Player.PlayerData.metadata['hunger'] - NADRP.Config.Player.HungerRate
        local newThirst = Player.PlayerData.metadata['thirst'] - NADRP.Config.Player.ThirstRate
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

RegisterNetEvent('NADRP:Server:SetMetaData', function(meta, data)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
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

RegisterNetEvent('NADRP:ToggleDuty', function()
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
    if Player.PlayerData.job.onduty then
        Player.Functions.SetJobDuty(false)
        TriggerClientEvent('NADRP:Notify', src, Lang:t('info.off_duty'))
    else
        Player.Functions.SetJobDuty(true)
        TriggerClientEvent('NADRP:Notify', src, Lang:t('info.on_duty'))
    end
    TriggerClientEvent('NADRP:Client:SetDuty', src, Player.PlayerData.job.onduty)
end)

-- Items

RegisterNetEvent('NADRP:Server:UseItem', function(item)
    local src = source
    if item and item.amount > 0 then
        if NADRP.Functions.CanUseItem(item.name) then
            NADRP.Functions.UseItem(src, item)
        end
    end
end)

RegisterNetEvent('NADRP:Server:RemoveItem', function(itemName, amount, slot)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(itemName, amount, slot)
end)

RegisterNetEvent('NADRP:Server:AddItem', function(itemName, amount, slot, info)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
    Player.Functions.AddItem(itemName, amount, slot, info)
end)

-- Non-Chat Command Calling (ex: NADRP-adminmenu)

RegisterNetEvent('NADRP:CallCommand', function(command, args)
    local src = source
    if NADRP.Commands.List[command] then
        local Player = NADRP.Functions.GetPlayer(src)
        if Player then
            local isGod = NADRP.Functions.HasPermission(src, 'god')
            local hasPerm = NADRP.Functions.HasPermission(src, NADRP.Commands.List[command].permission)
            local isPrincipal = IsPlayerAceAllowed(src, 'command')
            if (NADRP.Commands.List[command].permission == Player.PlayerData.job.name) or isGod or hasPerm or isPrincipal then
                if (NADRP.Commands.List[command].argsrequired and #NADRP.Commands.List[command].arguments ~= 0 and args[#NADRP.Commands.List[command].arguments] == nil) then
                    TriggerClientEvent('NADRP:Notify', src, Lang:t('error.missing_args2'), 'error')
                else
                    NADRP.Commands.List[command].callback(src, args)
                end
            else
                TriggerClientEvent('NADRP:Notify', src, Lang:t('error.no_access'), 'error')
            end
        end
    end
end)

-- Has Item Callback (can also use client function - NADRP.Functions.HasItem(item))

NADRP.Functions.CreateCallback('NADRP:HasItem', function(source, cb, items, amount)
    local src = source
    local retval = false
    local Player = NADRP.Functions.GetPlayer(src)
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
