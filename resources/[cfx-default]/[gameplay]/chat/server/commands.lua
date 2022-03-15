--[[ COMMANDS ]]--

local ESX = true

RegisterCommand('clear', function(source, args, rawCommand)
    TriggerClientEvent('chat:client:ClearChat', source)
end, false)

RegisterCommand('ooc', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    if player ~= false then
        local user = GetPlayerName(src)
            TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-message advert"><b>OOC {0} : </b> {1}</div>',
            args = { user, msg }
        })
    end
end, false)

RegisterCommand('twt', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    if player ~= false then
        if ESX then
            local name = getIdentity(src)
		        fal = name.firstname .. " " .. name.lastname
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message test"><b>Twitter : {0} : </b>{1}</div>',
                args = { fal, msg }
            })
        else
            local user = GetPlayerName(src)
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message test"><b>Twitter : {0} : </b>{1}</div>',
                args = { user, msg }
            })
        end
    end
end, false)

RegisterCommand('fbs', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    if player ~= false then
        if ESX then
            local name = getIdentity(src)
		        fal = name.firstname .. " " .. name.lastname
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message fb"><b>Facebook : {0} : </b>{1}</div>',
                args = { fal, msg }
            })
        else
            local user = GetPlayerName(src)
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message fb"><b>Facebook : {0} : </b>{1}</div>',
                args = { user, msg }
            })
        end
    end
end, false)

RegisterCommand('grm', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    if player ~= false then
        if ESX then
            local name = getIdentity(src)
		        fal = name.firstname .. " " .. name.lastname
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message insta"><b>Instagram : {0} : </b>{1}</div>',
                args = { fal, msg }
            })
        else
            local user = GetPlayerName(src)
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message insta"><b>Instagram : {0} : </b>{1}</div>',
                args = { user, msg }
            })
        end
    end
end, false)

RegisterCommand('web', function(source, args, rawCommand) 
    local src = source
    local msg = rawCommand:sub(5)
    if player ~= false then
        if ESX then
            local user = 'GUEST'
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message dweb"><b>DarkWeb : {0} : </b>{1}</div>',
                args = { user, msg }
            })
        else
            local user = 'GUEST'
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message dweb"><b>DarkWeb : {0} : </b>{1}</div>',
                args = { user, msg }
            })
        end
    end
end, false)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
			
		}
	else
		return nil
	end
end