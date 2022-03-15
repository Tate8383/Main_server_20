--allowed() is the function that determines if the player is allowed to use the dyno. DO NOT RENAME THE FUNCTION
--Place whatever job check code you want in here, return true if allowed, false if not
function allowed()
    return true
end


function LoadCompleteNotif()
	EndTextCommandThefeedPostTickerForced(1,1)
	ThefeedNextPostBackgroundColor(184)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(Config.NotiLoadCompleteMessage)
	EndTextCommandThefeedPostTicker(true, true)
	Wait(3000)
	EndTextCommandThefeedPostTickerForced(1,1)
end

function UnLoadCompleteNotif()
	EndTextCommandThefeedPostTickerForced(1,1)
	ThefeedNextPostBackgroundColor(184)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(Config.NotiUnLoadCompleteMessage)
	EndTextCommandThefeedPostTicker(true, true)
	Wait(3000)
	EndTextCommandThefeedPostTickerForced(1,1)
end

function FBBlockedNotif()
	EndTextCommandThefeedPostTickerForced(1,1)
	ThefeedNextPostBackgroundColor(6)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(Config.NotiFBBlockedMessage)
	EndTextCommandThefeedPostTicker(true, true)
	Wait(3000)
	EndTextCommandThefeedPostTickerForced(1,1)
end

function BlockedMessage()
	EndTextCommandThefeedPostTickerForced(1,1)
	ThefeedNextPostBackgroundColor(6)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(Config.NotiBlockedMessage)
	EndTextCommandThefeedPostTicker(true, true)
	Wait(3000)
	EndTextCommandThefeedPostTickerForced(1,1)
end





local entityEnumerator = {
    __gc = function(enum)
      if enum.destructor and enum.handle then
        enum.destructor(enum.handle)
      end
      enum.destructor = nil
      enum.handle = nil
    end
}
  
function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
        disposeFunc(iter)
        return
        end
        
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
        
        local next = true
        repeat
        coroutine.yield(id)
        next, id = moveFunc(iter)
        until not next
        
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function enumerate_vehicles() return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle) end

raising = false
function raiseBed()
	local playerPed = PlayerPedId()
    local playerCoords =  GetEntityCoords(playerPed)
	local closeCar
	for car in enumerate_vehicles() do
		local cvehicleCoords =  GetEntityCoords(car)
		if #(playerCoords - cvehicleCoords) < 5.0 then
			if validTruck(car) then
				closeCar = car
			end
		end
	end
	if validTruck(closeCar) then
		local idCheck = NetworkGetNetworkIdFromEntity(closeCar)
		TriggerServerEvent("ebu_flatbeds:deleteRope", idCheck)
		NetworkRequestControlOfEntity(closeCar)
		Citizen.CreateThread(function()
			while true do
				Wait(1)
				if raising then
					SetVehicleBulldozerArmPosition(closeCar, -1.0, false)
				else
					return
				end
			end
		end)
		Citizen.CreateThread(function()
			while raising do
				Wait(1500)
				raising = false
                SetVehicleBulldozerArmPosition(closeCar, 0.1, false)
			end
		end)
	end
end

 lowering = false
function lowerBed()
	local playerPed = PlayerPedId()
    local playerCoords =  GetEntityCoords(playerPed)
	local closeCar = nil
	for car in enumerate_vehicles() do
		local cvehicleCoords =  GetEntityCoords(car)
		if GetDistanceBetweenCoords(playerCoords, cvehicleCoords, true) < 5.0 then
			if validTruck(car) then
				closeCar = car
			end
		end
	end
    if validTruck(closeCar) then
		local idCheck = NetworkGetNetworkIdFromEntity(closeCar)
		TriggerServerEvent("ebu_flatbeds:deleteRope", idCheck)

		NetworkRequestControlOfEntity(closeCar)
		Citizen.CreateThread(function()
			while true do
				Wait(1)
				if lowering then
					SetVehicleBulldozerArmPosition(closeCar, 1.0, false)
				else
					return
				end
			end
		end)
		Citizen.CreateThread(function()
			while lowering do
				Wait(1000)
				lowering = false
			end
		end)
	end
end

RegisterCommand('+bedRaise', function()
    local playerPed = PlayerPedId()

    if not lowering and not IsPedInAnyVehicle(playerPed) and allowed() then
		raising = not raising
        raiseBed()
	elseif not IsPedInAnyVehicle(playerPed) and allowed() then
		lowering = not lowering
    end
end, false)
RegisterCommand('-bedRaise', function()
end)

RegisterCommand('+bedLower', function()
    local playerPed = PlayerPedId()

    if raising == false and not IsPedInAnyVehicle(playerPed) and allowed() then
        if lowering == true then
		    lowering = false
        else
            lowering = true
        end
		lowering = true
        lowerBed()
	elseif not IsPedInAnyVehicle(playerPed) and allowed() then
		raising = not raising
    end
end, false)
RegisterCommand('-bedLower', function()
end)

RegisterKeyMapping('+bedLower', 'bed Lower', 'keyboard', 'DOWN')
RegisterKeyMapping('+bedRaise', 'bed Raise', 'keyboard', 'UP')

RegisterKeyMapping('+flatbedAttach', 'Flatbed Attach', 'keyboard', 'E')
RegisterKeyMapping('+flatbedRope', 'Flatbed Remove Winch', 'keyboard', 'G')

RegisterKeyMapping('+flatbedWarp', 'Flatbed Get In Car', 'keyboard', 'F')

RegisterKeyMapping('+flatbedWind', 'Flatbed Wind', 'keyboard', 'LEFT')
RegisterKeyMapping('+flatbedUnWind', 'Flatbed Unwind', 'keyboard', 'RIGHT')