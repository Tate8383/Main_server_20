denalifw.Commands = {}
denalifw.Commands.List = {}

-- Register & Refresh Commands

function denalifw.Commands.Add(name, help, arguments, argsrequired, callback, permission)
    if type(permission) == 'string' then
        permission = permission:lower()
    else
        permission = 'user'
    end
    denalifw.Commands.List[name:lower()] = {
        name = name:lower(),
        permission = permission,
        help = help,
        arguments = arguments,
        argsrequired = argsrequired,
        callback = callback
    }
end

function denalifw.Commands.Refresh(source)
    local src = source
    local Player = denalifw.Functions.GetPlayer(src)
    local suggestions = {}
    if Player then
        for command, info in pairs(denalifw.Commands.List) do
            local isGod = denalifw.Functions.HasPermission(src, 'god')
            local hasPerm = denalifw.Functions.HasPermission(src, denalifw.Commands.List[command].permission)
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

denalifw.Commands.Add('tp', 'TP To Player or Coords (Admin Only)', { { name = 'id/x', help = 'ID of player or X position' }, { name = 'y', help = 'Y position' }, { name = 'z', help = 'Z position' } }, false, function(source, args)
    local src = source
    if args[1] and not args[2] and not args[3] then
        local target = GetPlayerPed(tonumber(args[1]))
        if target ~= 0 then
            local coords = GetEntityCoords(target)
            TriggerClientEvent('denalifw:Command:TeleportToPlayer', src, coords)
        else
            TriggerClientEvent('denalifw:Notify', src, Lang:t('error.not_online'), 'error')
        end
    else
        if args[1] and args[2] and args[3] then
            local x = tonumber(args[1])
            local y = tonumber(args[2])
            local z = tonumber(args[3])
            if (x ~= 0) and (y ~= 0) and (z ~= 0) then
                TriggerClientEvent('denalifw:Command:TeleportToCoords', src, x, y, z)
            else
                TriggerClientEvent('denalifw:Notify', src, Lang:t('error.wrong_format'), 'error')
            end
        else
            TriggerClientEvent('denalifw:Notify', src, Lang:t('error.missing_args'), 'error')
        end
    end
end, 'admin')

denalifw.Commands.Add('tpm', 'TP To Marker (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('denalifw:Command:GoToMarker', src)
end, 'admin')


denalifw.Commands.Add('togglepvp', 'Toggle PVP on the server (Admin Only)', {}, false, function(source)
    local src = source
    local pvp_state = QBConfig.Server.pvp
    QBConfig.Server.pvp = not pvp_state
    TriggerClientEvent('denalifw:Client:PvpHasToggled', -1, QBConfig.Server.pvp)
end, 'admin')
-- Permissions

denalifw.Commands.Add('addpermission', 'Give Player Permissions (God Only)', { { name = 'id', help = 'ID of player' }, { name = 'permission', help = 'Permission level' } }, true, function(source, args)
    local src = source
    local Player = denalifw.Functions.GetPlayer(tonumber(args[1]))
    local permission = tostring(args[2]):lower()
    if Player then
        denalifw.Functions.AddPermission(Player.PlayerData.source, permission)
    else
        TriggerClientEvent('denalifw:Notify', src, Lang:t('error.not_online'), 'error')
    end
end, 'god')

denalifw.Commands.Add('removepermission', 'Remove Players Permissions (God Only)', { { name = 'id', help = 'ID of player' } }, true, function(source, args)
    local src = source
    local Player = denalifw.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        denalifw.Functions.RemovePermission(Player.PlayerData.source)
    else
        TriggerClientEvent('denalifw:Notify', src, Lang:t('error.not_online'), 'error')
    end
end, 'god')

-- Vehicle

denalifw.Commands.Add('car', 'Spawn Vehicle (Admin Only)', { { name = 'model', help = 'Model name of the vehicle' } }, true, function(source, args)
    local src = source
    TriggerClientEvent('denalifw:Command:SpawnVehicle', src, args[1])
end, 'admin')

denalifw.Commands.Add('dv', 'Delete Vehicle (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('denalifw:Command:DeleteVehicle', src)
end, 'admin')

-- Money

denalifw.Commands.Add('givemoney', 'Give A Player Money (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'moneytype', help = 'Type of money (cash, bank, crypto)' }, { name = 'amount', help = 'Amount of money' } }, true, function(source, args)
    local src = source
    local Player = denalifw.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('denalifw:Notify', src, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

denalifw.Commands.Add('setmoney', 'Set Players Money Amount (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'moneytype', help = 'Type of money (cash, bank, crypto)' }, { name = 'amount', help = 'Amount of money' } }, true, function(source, args)
    local src = source
    local Player = denalifw.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('denalifw:Notify', src, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

-- Job

denalifw.Commands.Add('job', 'Check Your Job', {}, false, function(source)
    local src = source
    local PlayerJob = denalifw.Functions.GetPlayer(src).PlayerData.job
    TriggerClientEvent('denalifw:Notify', src, Lang:t('info.job_info', {value = PlayerJob.label, value2 = PlayerJob.grade.name, value3 = PlayerJob.onduty}))
end, 'user')

denalifw.Commands.Add('setjob', 'Set A Players Job (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'job', help = 'Job name' }, { name = 'grade', help = 'Grade' } }, true, function(source, args)
    local src = source
    local Player = denalifw.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetJob(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('denalifw:Notify', src, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

-- Gang

denalifw.Commands.Add('gang', 'Check Your Gang', {}, false, function(source)
    local src = source
    local PlayerGang = denalifw.Functions.GetPlayer(source).PlayerData.gang
    TriggerClientEvent('denalifw:Notify', src, Lang:t('info.gang_info', {value = PlayerGang.label, value2 = PlayerGang.grade.name}))
end, 'user')

denalifw.Commands.Add('setgang', 'Set A Players Gang (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'gang', help = 'Name of a gang' }, { name = 'grade', help = 'Grade' } }, true, function(source, args)
    local src = source
    local Player = denalifw.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetGang(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('denalifw:Notify', src, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

-- Inventory (should be in denalifw-inventory?)

denalifw.Commands.Add('clearinv', 'Clear Players Inventory (Admin Only)', { { name = 'id', help = 'Player ID' } }, false, function(source, args)
    local src = source
    local playerId = args[1] or src
    local Player = denalifw.Functions.GetPlayer(tonumber(playerId))
    if Player then
        Player.Functions.ClearInventory()
    else
        TriggerClientEvent('denalifw:Notify', src, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

-- Out of Character Chat

denalifw.Commands.Add('ooc', 'OOC Chat Message', {}, false, function(source, args)
    local src = source
    local message = table.concat(args, ' ')
    local Players = denalifw.Functions.GetPlayers()
    local Player = denalifw.Functions.GetPlayer(src)
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
        elseif denalifw.Functions.HasPermission(v, 'admin') then
            if denalifw.Functions.IsOptin(v) then
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

denalifw.Commands.Add('me', 'Show local message', {{name = 'message', help = 'Message to respond with'}}, false, function(source, args)
    local src = source
    local ped = GetPlayerPed(src)
    local pCoords = GetEntityCoords(ped)
    local msg = table.concat(args, ' ')
    if msg == '' then return end
    for k,v in pairs(denalifw.Functions.GetPlayers()) do
        local target = GetPlayerPed(v)
        local tCoords = GetEntityCoords(target)
        if #(pCoords - tCoords) < 20 then
            TriggerClientEvent('denalifw:Command:ShowMe3D', v, src, msg)
        end
    end
end, 'user')
