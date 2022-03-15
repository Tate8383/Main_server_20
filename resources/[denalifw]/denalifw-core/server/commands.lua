DenaliFW.Commands = {}
DenaliFW.Commands.List = {}

-- Register & Refresh Commands

function DenaliFW.Commands.Add(name, help, arguments, argsrequired, callback, permission)
    if type(permission) == 'string' then
        permission = permission:lower()
    else
        permission = 'user'
    end
    DenaliFW.Commands.List[name:lower()] = {
        name = name:lower(),
        permission = permission,
        help = help,
        arguments = arguments,
        argsrequired = argsrequired,
        callback = callback
    }
end

function DenaliFW.Commands.Refresh(source)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    local suggestions = {}
    if Player then
        for command, info in pairs(DenaliFW.Commands.List) do
            local isGod = DenaliFW.Functions.HasPermission(src, 'god')
            local hasPerm = DenaliFW.Functions.HasPermission(src, DenaliFW.Commands.List[command].permission)
            local isPrincipal = IsPlayerAceAllowed(src, 'command')
            if isGod or hasPerm or isPrincipal then
                suggestions[#suggestions + 1] = {
                    name = '/' .. command,
                    help = info.help,
                    params = info.arguments
                }
            end
        end
        TriggerClientEvent('chat:addSuggestions', tonumber(source), suggestions)
    end
end

-- Teleport

DenaliFW.Commands.Add('tp', 'TP To Player or Coords (Admin Only)', { { name = 'id/x', help = 'ID of player or X position' }, { name = 'y', help = 'Y position' }, { name = 'z', help = 'Z position' } }, false, function(source, args)
    local src = source
    if args[1] and not args[2] and not args[3] then
        local target = GetPlayerPed(tonumber(args[1]))
        if target ~= 0 then
            local coords = GetEntityCoords(target)
            TriggerClientEvent('DenaliFW:Command:TeleportToPlayer', src, coords)
        else
            TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.not_online'), 'error')
        end
    else
        if args[1] and args[2] and args[3] then
            local x = tonumber(args[1])
            local y = tonumber(args[2])
            local z = tonumber(args[3])
            if (x ~= 0) and (y ~= 0) and (z ~= 0) then
                TriggerClientEvent('DenaliFW:Command:TeleportToCoords', src, x, y, z)
            else
                TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.wrong_format'), 'error')
            end
        else
            TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.missing_args'), 'error')
        end
    end
end, 'admin')

DenaliFW.Commands.Add('tpm', 'TP To Marker (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('DenaliFW:Command:GoToMarker', src)
end, 'admin')


DenaliFW.Commands.Add('togglepvp', 'Toggle PVP on the server (Admin Only)', {}, false, function(source)
    local src = source
    local pvp_state = QBConfig.Server.pvp
    QBConfig.Server.pvp = not pvp_state
    TriggerClientEvent('DenaliFW:Client:PvpHasToggled', -1, QBConfig.Server.pvp)
end, 'admin')
-- Permissions

DenaliFW.Commands.Add('addpermission', 'Give Player Permissions (God Only)', { { name = 'id', help = 'ID of player' }, { name = 'permission', help = 'Permission level' } }, true, function(source, args)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(tonumber(args[1]))
    local permission = tostring(args[2]):lower()
    if Player then
        DenaliFW.Functions.AddPermission(Player.PlayerData.source, permission)
    else
        TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.not_online'), 'error')
    end
end, 'god')

DenaliFW.Commands.Add('removepermission', 'Remove Players Permissions (God Only)', { { name = 'id', help = 'ID of player' } }, true, function(source, args)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        DenaliFW.Functions.RemovePermission(Player.PlayerData.source)
    else
        TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.not_online'), 'error')
    end
end, 'god')

-- Vehicle

DenaliFW.Commands.Add('car', 'Spawn Vehicle (Admin Only)', { { name = 'model', help = 'Model name of the vehicle' } }, true, function(source, args)
    local src = source
    TriggerClientEvent('DenaliFW:Command:SpawnVehicle', src, args[1])
end, 'admin')

DenaliFW.Commands.Add('dv', 'Delete Vehicle (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('DenaliFW:Command:DeleteVehicle', src)
end, 'admin')

-- Money

DenaliFW.Commands.Add('givemoney', 'Give A Player Money (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'moneytype', help = 'Type of money (cash, bank, crypto)' }, { name = 'amount', help = 'Amount of money' } }, true, function(source, args)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

DenaliFW.Commands.Add('setmoney', 'Set Players Money Amount (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'moneytype', help = 'Type of money (cash, bank, crypto)' }, { name = 'amount', help = 'Amount of money' } }, true, function(source, args)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

-- Job

DenaliFW.Commands.Add('job', 'Check Your Job', {}, false, function(source)
    local src = source
    local PlayerJob = DenaliFW.Functions.GetPlayer(src).PlayerData.job
    TriggerClientEvent('DenaliFW:Notify', src, Lang:t('info.job_info', {value = PlayerJob.label, value2 = PlayerJob.grade.name, value3 = PlayerJob.onduty}))
end, 'user')

DenaliFW.Commands.Add('setjob', 'Set A Players Job (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'job', help = 'Job name' }, { name = 'grade', help = 'Grade' } }, true, function(source, args)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetJob(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

-- Gang

DenaliFW.Commands.Add('gang', 'Check Your Gang', {}, false, function(source)
    local src = source
    local PlayerGang = DenaliFW.Functions.GetPlayer(source).PlayerData.gang
    TriggerClientEvent('DenaliFW:Notify', src, Lang:t('info.gang_info', {value = PlayerGang.label, value2 = PlayerGang.grade.name}))
end, 'user')

DenaliFW.Commands.Add('setgang', 'Set A Players Gang (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'gang', help = 'Name of a gang' }, { name = 'grade', help = 'Grade' } }, true, function(source, args)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetGang(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

-- Inventory (should be in denalifw-inventory?)

DenaliFW.Commands.Add('clearinv', 'Clear Players Inventory (Admin Only)', { { name = 'id', help = 'Player ID' } }, false, function(source, args)
    local src = source
    local playerId = args[1] or src
    local Player = DenaliFW.Functions.GetPlayer(tonumber(playerId))
    if Player then
        Player.Functions.ClearInventory()
    else
        TriggerClientEvent('DenaliFW:Notify', src, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

-- Out of Character Chat

DenaliFW.Commands.Add('ooc', 'OOC Chat Message', {}, false, function(source, args)
    local src = source
    local message = table.concat(args, ' ')
    local Players = DenaliFW.Functions.GetPlayers()
    local Player = DenaliFW.Functions.GetPlayer(src)
    for k, v in pairs(Players) do
        if v == src then
            TriggerClientEvent('chat:addMessage', v, {
                color = { 0, 0, 255},
                multiline = true,
                args = {'OOC | '.. GetPlayerName(src), message}
            })
        elseif #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(v))) < 20.0 then
            TriggerClientEvent('chat:addMessage', v, {
                color = { 0, 0, 255},
                multiline = true,
                args = {'OOC | '.. GetPlayerName(src), message}
            })
        elseif DenaliFW.Functions.HasPermission(v, 'admin') then
            if DenaliFW.Functions.IsOptin(v) then
                TriggerClientEvent('chat:addMessage', v, {
                    color = { 0, 0, 255},
                    multiline = true,
                    args = {'Proxmity OOC | '.. GetPlayerName(src), message}
                })
                TriggerEvent('denalifw-log:server:CreateLog', 'ooc', 'OOC', 'white', '**' .. GetPlayerName(src) .. '** (CitizenID: ' .. Player.PlayerData.citizenid .. ' | ID: ' .. src .. ') **Message:** ' .. message, false)
            end
        end
    end
end, 'user')

-- Me command

DenaliFW.Commands.Add('me', 'Show local message', {{name = 'message', help = 'Message to respond with'}}, false, function(source, args)
    local src = source
    local ped = GetPlayerPed(src)
    local pCoords = GetEntityCoords(ped)
    local msg = table.concat(args, ' ')
    if msg == '' then return end
    for k,v in pairs(DenaliFW.Functions.GetPlayers()) do
        local target = GetPlayerPed(v)
        local tCoords = GetEntityCoords(target)
        if #(pCoords - tCoords) < 20 then
            TriggerClientEvent('DenaliFW:Command:ShowMe3D', v, src, msg)
        end
    end
end, 'user')
