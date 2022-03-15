NADRP = exports['NADRP-core']:GetCoreObject()
IsInside = false
ClosestHouse = nil
HasHouseKey = false
contractOpen = false
local isOwned = false
local cam = nil
local viewCam = false
local FrontCam = false
local stashLocation = nil
local outfitLocation = nil
local logoutLocation = nil
local OwnedHouseBlips = {}
local UnownedHouseBlips = {}
local CurrentDoorBell = 0
local rangDoorbell = nil
local houseObj = {}
local POIOffsets = nil
local entering = false
local data = nil
local CurrentHouse = nil
local RamsDone = 0
local keyholderMenu = {}
local keyholderOptions = {}
local fetchingHouseKeys = false

-- Functions

local function DrawText3Ds(x, y, z, text)
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

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function openHouseAnim()
    loadAnimDict("anim@heists@keycard@")
    TaskPlayAnim( PlayerPedId(), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Wait(400)
    ClearPedTasks(PlayerPedId())
end

local function openContract(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "toggle",
        status = bool,
    })
    contractOpen = bool
end

local function GetClosestPlayer()
    local closestPlayers = NADRP.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(PlayerPedId())
    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = #(pos - coords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end
	return closestPlayer, closestDistance
end

local function DoRamAnimation(bool)
    local ped = PlayerPedId()
    local dict = "missheistfbi3b_ig7"
    local anim = "lift_fibagent_loop"
    if bool then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(1)
        end
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 1, -1, false, false, false)
    else
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(1)
        end
        TaskPlayAnim(ped, dict, "exit", 8.0, 8.0, -1, 1, -1, false, false, false)
    end
end

local function setViewCam(coords, h, yaw)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z, yaw, 0.00, h, 80.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    viewCam = true
end

local function InstructionButton(ControlButton)
    ScaleformMovieMethodAddParamPlayerNameString(ControlButton)
end

local function InstructionButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

local function CreateInstuctionScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    InstructionButton(GetControlInstructionalButton(1, 194, true))
    InstructionButtonMessage(Lang:t("info.exit_camera"))
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()
    return scaleform
end

local function FrontDoorCam(coords)
    DoScreenFadeOut(150)
    Wait(500)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z + 0.5, 0.0, 0.00, coords.h - 180, 80.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    TriggerEvent('NADRP-weathersync:client:EnableSync')
    FrontCam = true
    FreezeEntityPosition(PlayerPedId(), true)
    Wait(500)
    DoScreenFadeIn(150)
    SendNUIMessage({
        type = "frontcam",
        toggle = true,
        label = Config.Houses[ClosestHouse].adress
    })
    CreateThread(function()
        while FrontCam do
            local instructions = CreateInstuctionScaleform("instructional_buttons")
            DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
            SetTimecycleModifier("scanline_cam_cheap")
            SetTimecycleModifierStrength(1.0)
            if IsControlJustPressed(1, 194) then -- Backspace
                DoScreenFadeOut(150)
                SendNUIMessage({
                    type = "frontcam",
                    toggle = false,
                })
                Wait(500)
                RenderScriptCams(false, true, 500, true, true)
                FreezeEntityPosition(PlayerPedId(), false)
                SetCamActive(cam, false)
                DestroyCam(cam, true)
                ClearTimecycleModifier("scanline_cam_cheap")
                cam = nil
                FrontCam = false
                Wait(500)
                DoScreenFadeIn(150)
            end

            local getCameraRot = GetCamRot(cam, 2)

            -- ROTATE UP
            if IsControlPressed(0, 32) then -- W
                if getCameraRot.x <= 0.0 then
                    SetCamRot(cam, getCameraRot.x + 0.7, 0.0, getCameraRot.z, 2)
                end
            end

            -- ROTATE DOWN
            if IsControlPressed(0, 33) then -- S
                if getCameraRot.x >= -50.0 then
                    SetCamRot(cam, getCameraRot.x - 0.7, 0.0, getCameraRot.z, 2)
                end
            end

            -- ROTATE LEFT
            if IsControlPressed(0, 34) then -- A
                SetCamRot(cam, getCameraRot.x, 0.0, getCameraRot.z + 0.7, 2)
            end

            -- ROTATE RIGHT
            if IsControlPressed(0, 35) then -- D
                SetCamRot(cam, getCameraRot.x, 0.0, getCameraRot.z - 0.7, 2)
            end

            Wait(1)
        end
    end)
end

local function disableViewCam()
    if viewCam then
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        viewCam = false
    end
end

local function SetClosestHouse()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    if not IsInside then
        for id, house in pairs(Config.Houses) do
            local distcheck = #(pos - vector3(Config.Houses[id].coords.enter.x, Config.Houses[id].coords.enter.y, Config.Houses[id].coords.enter.z))
            if current ~= nil then
                if distcheck < dist then
                    current = id
                    dist = distcheck
                end
            else
                dist = distcheck
                current = id
            end
        end
        ClosestHouse = current
        if ClosestHouse ~= nil and tonumber(dist) < 30 then
            NADRP.Functions.TriggerCallback('NADRP-houses:server:ProximityKO', function(key, owned)
                HasHouseKey = key
                isOwned = owned
            end, ClosestHouse)
        end
    end
    TriggerEvent('NADRP-garages:client:setHouseGarage', ClosestHouse, HasHouseKey)
end

local function setHouseLocations()
    if ClosestHouse ~= nil then
        NADRP.Functions.TriggerCallback('NADRP-houses:server:getHouseLocations', function(result)
            if result ~= nil then
                if result.stash ~= nil then
                    stashLocation = json.decode(result.stash)
                end

                if result.outfit ~= nil then
                    outfitLocation = json.decode(result.outfit)
                end

                if result.logout ~= nil then
                    logoutLocation = json.decode(result.logout)
                end
            end
        end, ClosestHouse)
    end
end

local function UnloadDecorations()
	if ObjectList ~= nil then
		for k, v in pairs(ObjectList) do
			if DoesEntityExist(v.object) then
				DeleteObject(v.object)
			end
		end
	end
end

local function LoadDecorations(house)
	if Config.Houses[house].decorations == nil or next(Config.Houses[house].decorations) == nil then
		NADRP.Functions.TriggerCallback('NADRP-houses:server:getHouseDecorations', function(result)
			Config.Houses[house].decorations = result
			if Config.Houses[house].decorations ~= nil then
				ObjectList = {}
				for k, v in pairs(Config.Houses[house].decorations) do
					if Config.Houses[house].decorations[k] ~= nil then
						if Config.Houses[house].decorations[k].object ~= nil then
							if DoesEntityExist(Config.Houses[house].decorations[k].object) then
								DeleteObject(Config.Houses[house].decorations[k].object)
							end
						end
						local modelHash = GetHashKey(Config.Houses[house].decorations[k].hashname)
						RequestModel(modelHash)
						while not HasModelLoaded(modelHash) do
							Wait(10)
						end
						local decorateObject = CreateObject(modelHash, Config.Houses[house].decorations[k].x, Config.Houses[house].decorations[k].y, Config.Houses[house].decorations[k].z, false, false, false)
						SetEntityRotation(decorateObject, Config.Houses[house].decorations[k].rotx, Config.Houses[house].decorations[k].roty, Config.Houses[house].decorations[k].rotz)
						ObjectList[Config.Houses[house].decorations[k].objectId] = {hashname = Config.Houses[house].decorations[k].hashname, x = Config.Houses[house].decorations[k].x, y = Config.Houses[house].decorations[k].y, z = Config.Houses[house].decorations[k].z, rotx = Config.Houses[house].decorations[k].rotx, roty = Config.Houses[house].decorations[k].roty, rotz = Config.Houses[house].decorations[k].rotz, object = decorateObject, objectId = Config.Houses[house].decorations[k].objectId}
						FreezeEntityPosition(decorateObject, true)
					end
				end
			end
		end, house)
	elseif Config.Houses[house].decorations ~= nil then
		ObjectList = {}
		for k, v in pairs(Config.Houses[house].decorations) do
			if Config.Houses[house].decorations[k] ~= nil then
				if Config.Houses[house].decorations[k].object ~= nil then
					if DoesEntityExist(Config.Houses[house].decorations[k].object) then
						DeleteObject(Config.Houses[house].decorations[k].object)
					end
				end
				local modelHash = GetHashKey(Config.Houses[house].decorations[k].hashname)
				RequestModel(modelHash)
				while not HasModelLoaded(modelHash) do
					Wait(10)
				end
				local decorateObject = CreateObject(modelHash, Config.Houses[house].decorations[k].x, Config.Houses[house].decorations[k].y, Config.Houses[house].decorations[k].z, false, false, false)
				Config.Houses[house].decorations[k].object = decorateObject
				SetEntityRotation(decorateObject, Config.Houses[house].decorations[k].rotx, Config.Houses[house].decorations[k].roty, Config.Houses[house].decorations[k].rotz)
				ObjectList[Config.Houses[house].decorations[k].objectId] = {hashname = Config.Houses[house].decorations[k].hashname, x = Config.Houses[house].decorations[k].x, y = Config.Houses[house].decorations[k].y, z = Config.Houses[house].decorations[k].z, rotx = Config.Houses[house].decorations[k].rotx, roty = Config.Houses[house].decorations[k].roty, rotz = Config.Houses[house].decorations[k].rotz, object = decorateObject, objectId = Config.Houses[house].decorations[k].objectId}
				FreezeEntityPosition(decorateObject, true)
			end
		end
	end
end

local function CheckDistance(target, distance)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    return #(pos - target) <= distance
end

-- GUI Functions

function CloseMenuFull()
    exports['NADRP-menu']:closeMenu()
end

local function RemoveHouseKey(citizenData)
    TriggerServerEvent('NADRP-houses:server:removeHouseKey', ClosestHouse, citizenData)
    CloseMenuFull()
end

local function getKeyHolders()
    if fetchingHouseKeys then return end
    fetchingHouseKeys = true

    local p = promise.new()
    NADRP.Functions.TriggerCallback('NADRP-houses:server:getHouseKeyHolders', function(holders)
        p:resolve(holders)
    end,ClosestHouse)

    return Citizen.Await(p)
end

function HouseKeysMenu()
    local holders = getKeyHolders()
    fetchingHouseKeys = false

    if holders == nil or next(holders) == nil then
        NADRP.Functions.Notify(Lang:t("error.no_key_holders"), "error", 3500)
        CloseMenuFull()
    else
        keyholderMenu = {}

        for k, v in pairs(holders) do
            keyholderMenu[#keyholderMenu+1] = {
                header = holders[k].firstname .. " " .. holders[k].lastname,
                params = {
                    event = "NADRP-houses:client:OpenClientOptions",
                    args = {
                        citizenData = holders[k]
                    }
                }
            }
        end
        exports['NADRP-menu']:openMenu(keyholderMenu)
    end

end

local function optionMenu(citizenData)
    keyholderOptions = {
        {
            header = Lang:t("menu.remove_key"),
            params = {
                event = "NADRP-houses:client:RevokeKey",
                args = {
                    citizenData = citizenData
                }
            }
        },
        {
            header = Lang:t("menu.back"),
            params = {
                event = "NADRP-houses:client:removeHouseKey",
                args = {}
            }
        },
    }

    exports['NADRP-menu']:openMenu(keyholderOptions)
end

-- Shell Configuration
local function getDataForHouseTier(house, coords)
    local houseTier = Config.Houses[house].tier
    local shells = {
        [1] = function(coords) return exports['NADRP-interior']:CreateApartmentShell(coords) end,
        [2] = function(coords) return exports['NADRP-interior']:CreateTier1House(coords) end,
        [3] = function(coords) return exports['NADRP-interior']:CreateTrevorsShell(coords) end,
        [4] = function(coords) return exports['NADRP-interior']:CreateCaravanShell(coords) end,
        [5] = function(coords) return exports['NADRP-interior']:CreateLesterShell(coords) end,
        [6] = function(coords) return exports['NADRP-interior']:CreateRanchShell(coords) end
    }

    if not shells[houseTier] then
        NADRP.Functions.Notify(Lang:t("error.invalid_tier"), 'error')
        return nil
    else
        return shells[houseTier](coords)
    end
end

-- If you are using paid shells the comment function above and uncomment this or grab the ones you need

-- local function getDataForHouseTier(house, coords)
--     if Config.Houses[house].tier == 1 then
--         return exports['NADRP-interior']:CreateApartmentShell(coords)
--     elseif Config.Houses[house].tier == 2 then
--         return exports['NADRP-interior']:CreateTier1House(coords)
--     elseif Config.Houses[house].tier == 3 then
--         return exports['NADRP-interior']:CreateTrevorsShell(coords)
--     elseif Config.Houses[house].tier == 4 then
--         return exports['NADRP-interior']:CreateCaravanShell(coords)
--     elseif Config.Houses[house].tier == 5 then
--         return exports['NADRP-interior']:CreateLesterShell(coords)
--     elseif Config.Houses[house].tier == 6 then
--         return exports['NADRP-interior']:CreateRanchShell(coords)
--     elseif Config.Houses[house].tier == 7 then
--         return exports['NADRP-interior']:CreateFranklinAunt(coords)
--     elseif Config.Houses[house].tier == 8 then
--         return exports['NADRP-interior']:CreateMedium2(coords)
--     elseif Config.Houses[house].tier == 9 then
--         return exports['NADRP-interior']:CreateMedium3(coords)
--     elseif Config.Houses[house].tier == 10 then
--         return exports['NADRP-interior']:CreateBanham(coords)
--     elseif Config.Houses[house].tier == 11 then
--         return exports['NADRP-interior']:CreateWestons(coords)
--     elseif Config.Houses[house].tier == 12 then
--         return exports['NADRP-interior']:CreateWestons2(coords)
--     elseif Config.Houses[house].tier == 13 then
--         return exports['NADRP-interior']:CreateClassicHouse(coords)
--     elseif Config.Houses[house].tier == 14 then
--         return exports['NADRP-interior']:CreateClassicHouse2(coords)
--     elseif Config.Houses[house].tier == 15 then
--         return exports['NADRP-interior']:CreateClassicHouse3(coords)
--     elseif Config.Houses[house].tier == 16 then
--         return exports['NADRP-interior']:CreateHighend1(coords)
--     elseif Config.Houses[house].tier == 17 then
--         return exports['NADRP-interior']:CreateHighend2(coords)
--     elseif Config.Houses[house].tier == 18 then
--         return exports['NADRP-interior']:CreateHighend3(coords)
--     elseif Config.Houses[house].tier == 19 then
--         return exports['NADRP-interior']:CreateHighend(coords)
--     elseif Config.Houses[house].tier == 20 then
--         return exports['NADRP-interior']:CreateHighendV2(coords)
--     elseif Config.Houses[house].tier == 21 then
--         return exports['NADRP-interior']:CreateMichael(coords)
--     elseif Config.Houses[house].tier == 22 then
--         return exports['NADRP-interior']:CreateStashHouse(coords)
--     elseif Config.Houses[house].tier == 23 then
--         return exports['NADRP-interior']:CreateStashHouse2(coords)
--     elseif Config.Houses[house].tier == 24 then
--         return exports['NADRP-interior']:CreateContainer(coords)
--     elseif Config.Houses[house].tier == 25 then
--         return exports['NADRP-interior']:CreateGarageLow(coords)
--     elseif Config.Houses[house].tier == 26 then
--         return exports['NADRP-interior']:CreateGarageMed(coords)
--     elseif Config.Houses[house].tier == 27 then
--         return exports['NADRP-interior']:CreateGarageHigh(coords)
--     elseif Config.Houses[house].tier == 28 then
--         return exports['NADRP-interior']:CreateOffice1(coords)
--     elseif Config.Houses[house].tier == 29 then
--         return exports['NADRP-interior']:CreateOffice2(coords)
--     elseif Config.Houses[house].tier == 30 then
--         return exports['NADRP-interior']:CreateOfficeBig(coords)
--     elseif Config.Houses[house].tier == 31 then
--         return exports['NADRP-interior']:CreateBarber(coords)
--     elseif Config.Houses[house].tier == 32 then
--         return exports['NADRP-interior']:CreateGunstore(coords)
--     elseif Config.Houses[house].tier == 33 then
--         return exports['NADRP-interior']:CreateStore1(coords)
--     elseif Config.Houses[house].tier == 34 then
--         return exports['NADRP-interior']:CreateStore2(coords)
--     elseif Config.Houses[house].tier == 35 then
--         return exports['NADRP-interior']:CreateStore3(coords)
--     elseif Config.Houses[house].tier == 36 then
--         return exports['NADRP-interior']:CreateWarehouse1(coords)
--     elseif Config.Houses[house].tier == 37 then
--         return exports['NADRP-interior']:CreateWarehouse2(coords)
--     elseif Config.Houses[house].tier == 38 then
--         return exports['NADRP-interior']:CreateWarehouse3(coords)
--     elseif Config.Houses[house].tier == 39 then
--         return exports['NADRP-interior']:CreateK4Coke(coords)
--     elseif Config.Houses[house].tier == 40 then
--         return exports['NADRP-interior']:CreateK4Meth(coords)
--     elseif Config.Houses[house].tier == 41 then
--         return exports['NADRP-interior']:CreateK4Weed(coords)
--     elseif Config.Houses[house].tier == 42 then
--         return exports['NADRP-interior']:CreateContainer2(coords)
--     elseif Config.Houses[house].tier == 43 then
--         return exports['NADRP-interior']:CreateFurniStash1(coords)
--     elseif Config.Houses[house].tier == 44 then
--         return exports['NADRP-interior']:CreateFurniStash3(coords)
--     elseif Config.Houses[house].tier == 45 then
--         return exports['NADRP-interior']:CreateFurniLow(coords)
--     elseif Config.Houses[house].tier == 46 then
--         return exports['NADRP-interior']:CreateFurniMid(coords)
--     elseif Config.Houses[house].tier == 47 then
--         return exports['NADRP-interior']:CreateFurniMotel(coords)
--     elseif Config.Houses[house].tier == 48 then
--         return exports['NADRP-interior']:CreateFurniMotelClassic(coords)
--     elseif Config.Houses[house].tier == 49 then
--         return exports['NADRP-interior']:CreateFurniMotelStandard(coords)
--     elseif Config.Houses[house].tier == 50 then
--         return exports['NADRP-interior']:CreateFurniMotelHigh(coords)
--     elseif Config.Houses[house].tier == 51 then
--         return exports['NADRP-interior']:CreateFurniMotelModern(coords)
--     elseif Config.Houses[house].tier == 52 then
--         return exports['NADRP-interior']:CreateFurniMotelModern2(coords)
--     elseif Config.Houses[house].tier == 53 then
--         return exports['NADRP-interior']:CreateFurniMotelModern3(coords)
--     elseif Config.Houses[house].tier == 54 then
--         return exports['NADRP-interior']:CreateCoke(coords)
--     elseif Config.Houses[house].tier == 55 then
--         return exports['NADRP-interior']:CreateCoke2(coords)
--     elseif Config.Houses[house].tier == 56 then
--         return exports['NADRP-interior']:CreateMeth(coords)
--     elseif Config.Houses[house].tier == 57 then
--         return exports['NADRP-interior']:CreateWeed(coords)
--     elseif Config.Houses[house].tier == 58 then
--         return exports['NADRP-interior']:CreateWeed2(coords)
--     elseif Config.Houses[house].tier == 59 then
--         return exports['NADRP-interior']:CreateMansion(coords)
--     elseif Config.Houses[house].tier == 60 then
--         return exports['NADRP-interior']:CreateMansion2(coords)
--     elseif Config.Houses[house].tier == 61 then
--         return exports['NADRP-interior']:CreateMansion3(coords)
--     else
--         NADRP.Functions.Notify(Lang:t("error.invalid_tier"), 'error')
--     end
-- end

local function enterOwnedHouse(house)
    CurrentHouse = house
    ClosestHouse = house
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    openHouseAnim()
    IsInside = true
    Wait(250)
    local coords = { x = Config.Houses[house].coords.enter.x, y = Config.Houses[house].coords.enter.y, z= Config.Houses[house].coords.enter.z - Config.MinZOffset}
    LoadDecorations(house)
    data = getDataForHouseTier(house, coords)
    Wait(100)
    houseObj = data[1]
    POIOffsets = data[2]
    entering = true
    Wait(500)
    TriggerServerEvent('NADRP-houses:server:SetInsideMeta', house, true)
    --TriggerEvent('NADRP-weathersync:client:DisableSync')
    TriggerEvent('NADRP-weathersync:client:EnableSync')
    TriggerEvent('NADRP-weed:client:getHousePlants', house)
    entering = false
    setHouseLocations()
    CloseMenuFull()
end

local function LeaveOwnedHouse(house)
    if not FrontCam then
        IsInside = false
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
        openHouseAnim()
        Wait(250)
        DoScreenFadeOut(250)
        Wait(500)
        exports['NADRP-interior']:DespawnInterior(houseObj, function()
            UnloadDecorations()
            TriggerEvent('NADRP-weathersync:client:EnableSync')
            Wait(250)
            DoScreenFadeIn(250)
            SetEntityCoords(PlayerPedId(), Config.Houses[CurrentHouse].coords.enter.x, Config.Houses[CurrentHouse].coords.enter.y, Config.Houses[CurrentHouse].coords.enter.z + 0.2)
            SetEntityHeading(PlayerPedId(), Config.Houses[CurrentHouse].coords.enter.h)
            TriggerEvent('NADRP-weed:client:leaveHouse')
            TriggerServerEvent('NADRP-houses:server:SetInsideMeta', house, false)
            CurrentHouse = nil
        end)
    end
end

local function enterNonOwnedHouse(house)
    CurrentHouse = house
    ClosestHouse = house
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    openHouseAnim()
    IsInside = true
    Wait(250)
    local coords = { x = Config.Houses[ClosestHouse].coords.enter.x, y = Config.Houses[ClosestHouse].coords.enter.y, z= Config.Houses[ClosestHouse].coords.enter.z - Config.MinZOffset}
    LoadDecorations(house)
    data = getDataForHouseTier(house, coords)
    houseObj = data[1]
    POIOffsets = data[2]
    entering = true
    Wait(500)
    TriggerServerEvent('NADRP-houses:server:SetInsideMeta', house, true)
    --TriggerEvent('NADRP-weathersync:client:DisableSync')
    TriggerEvent('NADRP-weathersync:client:EnableSync')
    TriggerEvent('NADRP-weed:client:getHousePlants', house)
    entering = false
    InOwnedHouse = true
    setHouseLocations()
end

-- Is there a purpose to this?
local function LeaveNonOwnedHouse(house)
    if not FrontCam then
        IsInside = false
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
        openHouseAnim()
        Wait(250)
        DoScreenFadeOut(250)
        Wait(500)
        exports['NADRP-interior']:DespawnInterior(houseObj, function()
            UnloadDecorations()
            TriggerEvent('NADRP-weathersync:client:EnableSync')
            Wait(250)
            DoScreenFadeIn(250)
            SetEntityCoords(PlayerPedId(), Config.Houses[CurrentHouse].coords.enter.x, Config.Houses[CurrentHouse].coords.enter.y, Config.Houses[CurrentHouse].coords.enter.z + 0.2)
            SetEntityHeading(PlayerPedId(), Config.Houses[CurrentHouse].coords.enter.h)
            InOwnedHouse = false
            TriggerEvent('NADRP-weed:client:leaveHouse')
            TriggerServerEvent('NADRP-houses:server:SetInsideMeta', house, false)
            CurrentHouse = nil
        end)
    end
end

local function isNearHouses()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    if ClosestHouse ~= nil then
        local dist = #(pos - vector3(Config.Houses[ClosestHouse].coords.enter.x, Config.Houses[ClosestHouse].coords.enter.y, Config.Houses[ClosestHouse].coords.enter.z))
        if dist <= 1.5 then
            if HasHouseKey then
                return true
            end
        end
    end
end

exports('isNearHouses', isNearHouses)

-- Events

RegisterNetEvent('NADRP-houses:server:sethousedecorations', function(house, decorations)
	Config.Houses[house].decorations = decorations
	if IsInside and ClosestHouse == house then
		LoadDecorations(house)
	end
end)

RegisterNetEvent('NADRP-houses:client:sellHouse', function()
    if ClosestHouse and HasHouseKey then
        TriggerServerEvent('NADRP-houses:server:viewHouse', ClosestHouse)
    end
end)

RegisterNetEvent('NADRP-houses:client:EnterHouse', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    if ClosestHouse ~= nil then
        local dist = #(pos - vector3(Config.Houses[ClosestHouse].coords.enter.x, Config.Houses[ClosestHouse].coords.enter.y, Config.Houses[ClosestHouse].coords.enter.z))
        if dist <= 1.5 then
            if HasHouseKey then
                enterOwnedHouse(ClosestHouse)
            else
                if not Config.Houses[ClosestHouse].locked then
                    enterNonOwnedHouse(ClosestHouse)
                end
            end
        end
    end
end)

RegisterNetEvent('NADRP-houses:client:RequestRing', function()
    if ClosestHouse ~= nil then
        TriggerServerEvent('NADRP-houses:server:RingDoor', ClosestHouse)
    end
end)

AddEventHandler('NADRP:Client:OnPlayerLoaded', function()
    TriggerServerEvent('NADRP-houses:server:setHouses')
    SetClosestHouse()
    TriggerEvent('NADRP-houses:client:setupHouseBlips')
    if Config.UnownedBlips then TriggerEvent('NADRP-houses:client:setupHouseBlips2') end
    Wait(100)
    TriggerEvent('NADRP-garages:client:setHouseGarage', ClosestHouse, HasHouseKey)
    TriggerServerEvent("NADRP-houses:server:setHouses")
end)

RegisterNetEvent('NADRP:Client:OnPlayerUnload', function()
    IsInside = false
    ClosestHouse = nil
    HasHouseKey = false
    isOwned = false
    for k, v in pairs(OwnedHouseBlips) do
        RemoveBlip(v)
    end
    if Config.UnownedBlips then
        for k,v in pairs(UnownedHouseBlips) do
            RemoveBlip(v)
        end
    end
end)

RegisterNetEvent('NADRP-houses:client:setHouseConfig', function(houseConfig)
    Config.Houses = houseConfig
end)

RegisterNetEvent('NADRP-houses:client:lockHouse', function(bool, house)
    Config.Houses[house].locked = bool
end)

RegisterNetEvent('NADRP-houses:client:createHouses', function(price, tier)
    local pos = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
	local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street = GetStreetNameFromHashKey(s1)
    local coords = {
        enter 	= { x = pos.x, y = pos.y, z = pos.z, h = heading},
        cam 	= { x = pos.x, y = pos.y, z = pos.z, h = heading, yaw = -10.00},
    }
    street = street:gsub("%-", " ")
    TriggerServerEvent('NADRP-houses:server:addNewHouse', street, coords, price, tier)
    if Config.UnownedBlips then TriggerServerEvent('NADRP-houses:server:createBlip') end
end)

RegisterNetEvent('NADRP-houses:client:addGarage', function()
    if ClosestHouse ~= nil then
        local pos = GetEntityCoords(PlayerPedId())
        local heading = GetEntityHeading(PlayerPedId())
        local coords = {
            x = pos.x,
            y = pos.y,
            z = pos.z,
            h = heading,
        }
        TriggerServerEvent('NADRP-houses:server:addGarage', ClosestHouse, coords)
    else
        NADRP.Functions.Notify(Lang:t("error.no_house"), "error")
    end
end)

RegisterNetEvent('NADRP-houses:client:toggleDoorlock', function()
    local pos = GetEntityCoords(PlayerPedId())
    local dist = #(pos - vector3(Config.Houses[ClosestHouse].coords.enter.x, Config.Houses[ClosestHouse].coords.enter.y, Config.Houses[ClosestHouse].coords.enter.z))
    if dist <= 1.5 then
        if HasHouseKey then
            if Config.Houses[ClosestHouse].locked then
                TriggerServerEvent('NADRP-houses:server:lockHouse', false, ClosestHouse)
                NADRP.Functions.Notify(Lang:t("success.unlocked"), "success", 2500)
            else
                TriggerServerEvent('NADRP-houses:server:lockHouse', true, ClosestHouse)
                NADRP.Functions.Notify(Lang:t("error.locked"), "error", 2500)
            end
        else
            NADRP.Functions.Notify(Lang:t("error.no_keys"), "error", 3500)
        end
    else
        NADRP.Functions.Notify(Lang:t("error.no_door"), "error", 3500)
    end
end)

RegisterNetEvent('NADRP-houses:client:RingDoor', function(player, house)
    if ClosestHouse == house and IsInside then
        CurrentDoorBell = player
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "doorbell", 0.1)
        NADRP.Functions.Notify(Lang:t("info.door_ringing"))
    end
end)

RegisterNetEvent('NADRP-houses:client:giveHouseKey', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 and ClosestHouse ~= nil then
        local playerId = GetPlayerServerId(player)
        local pedpos = GetEntityCoords(PlayerPedId())
        local housedist = #(pedpos - vector3(Config.Houses[ClosestHouse].coords.enter.x, Config.Houses[ClosestHouse].coords.enter.y, Config.Houses[ClosestHouse].coords.enter.z))
        if housedist < 10 then
            TriggerServerEvent('NADRP-houses:server:giveHouseKey', playerId, ClosestHouse)
        else
            NADRP.Functions.Notify(Lang:t("error.no_door"), "error")
        end
    elseif ClosestHouse == nil then
        NADRP.Functions.Notify(Lang:t("error.no_house"), "error")
    else
        NADRP.Functions.Notify(Lang:t("error.no_one_near"), "error")
    end
end)

RegisterNetEvent('NADRP-houses:client:removeHouseKey', function()
    if ClosestHouse ~= nil then
        local pedpos = GetEntityCoords(PlayerPedId())
        local housedist = #(pedpos - vector3(Config.Houses[ClosestHouse].coords.enter.x, Config.Houses[ClosestHouse].coords.enter.y, Config.Houses[ClosestHouse].coords.enter.z))
        if housedist <= 5 then
            NADRP.Functions.TriggerCallback('NADRP-houses:server:getHouseOwner', function(result)
                if NADRP.Functions.GetPlayerData().citizenid == result then
                    HouseKeysMenu()
                else
                    NADRP.Functions.Notify(Lang:t("error.not_owner"), "error")
                end
            end, ClosestHouse)
        else
            NADRP.Functions.Notify(Lang:t("error.no_door"), "error")
        end
    else
        NADRP.Functions.Notify(Lang:t("error.no_door"), "error")
    end
end)

RegisterNetEvent('NADRP-houses:client:RevokeKey', function(data)
    RemoveHouseKey(data.citizenData)
end)

RegisterNetEvent('NADRP-houses:client:refreshHouse', function(data)
    Wait(100)
    SetClosestHouse()
end)

RegisterNetEvent('NADRP-houses:client:SpawnInApartment', function(house)
    local pos = GetEntityCoords(PlayerPedId())
    if rangDoorbell ~= nil then
        if #(pos - vector3(Config.Houses[house].coords.enter.x, Config.Houses[house].coords.enter.y, Config.Houses[house].coords.enter.z)) > 5 then
            return
        end
    end
    ClosestHouse = house
    enterNonOwnedHouse(house)
end)

RegisterNetEvent('NADRP-houses:client:enterOwnedHouse', function(house)
    NADRP.Functions.GetPlayerData(function(PlayerData)
		if PlayerData.metadata["injail"] == 0 then
			enterOwnedHouse(house)
		end
	end)
end)

RegisterNetEvent('NADRP-houses:client:LastLocationHouse', function(houseId)
    NADRP.Functions.GetPlayerData(function(PlayerData)
		if PlayerData.metadata["injail"] == 0 then
			enterOwnedHouse(houseId)
		end
	end)
end)

RegisterNetEvent('NADRP-houses:client:setupHouseBlips', function() -- Setup owned on load
    CreateThread(function()
        Wait(2000)
        if LocalPlayer.state['isLoggedIn'] then
            NADRP.Functions.TriggerCallback('NADRP-houses:server:getOwnedHouses', function(ownedHouses)
                if ownedHouses then
                    for k, v in pairs(ownedHouses) do
                        local house = Config.Houses[ownedHouses[k]]
                        HouseBlip = AddBlipForCoord(house.coords.enter.x, house.coords.enter.y, house.coords.enter.z)
                        SetBlipSprite (HouseBlip, 40)
                        SetBlipDisplay(HouseBlip, 4)
                        SetBlipScale  (HouseBlip, 0.65)
                        SetBlipAsShortRange(HouseBlip, true)
                        SetBlipColour(HouseBlip, 3)
                        AddTextEntry('OwnedHouse', house.adress)
                        BeginTextCommandSetBlipName('OwnedHouse')
                        EndTextCommandSetBlipName(HouseBlip)
                        OwnedHouseBlips[#OwnedHouseBlips+1] = HouseBlip
                    end
                end
            end)
        end
    end)
end)

RegisterNetEvent('NADRP-houses:client:setupHouseBlips2', function() -- Setup unowned on load
    for k,v in pairs(Config.Houses) do
        if not v.owned then
            HouseBlip2 = AddBlipForCoord(v.coords.enter.x, v.coords.enter.y, v.coords.enter.z)
            SetBlipSprite (HouseBlip2, 40)
            SetBlipDisplay(HouseBlip2, 4)
            SetBlipScale  (HouseBlip2, 0.65)
            SetBlipAsShortRange(HouseBlip2, true)
            SetBlipColour(HouseBlip2, 3)
            AddTextEntry('UnownedHouse', Lang:t("info.house_for_sale"))
            BeginTextCommandSetBlipName('UnownedHouse')
            EndTextCommandSetBlipName(HouseBlip2)
            UnownedHouseBlips[#UnownedHouseBlips+1] = HouseBlip2
        end
    end
end)

RegisterNetEvent('NADRP-houses:client:createBlip', function(coords) -- Create unowned on command
    NewHouseBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite (NewHouseBlip, 40)
    SetBlipDisplay(NewHouseBlip, 4)
    SetBlipScale  (NewHouseBlip, 0.65)
    SetBlipAsShortRange(NewHouseBlip, true)
    SetBlipColour(NewHouseBlip, 3)
    AddTextEntry('NewHouseBlip', Lang:t("info.house_for_sale"))
    BeginTextCommandSetBlipName('NewHouseBlip')
    EndTextCommandSetBlipName(NewHouseBlip)
    UnownedHouseBlips[#UnownedHouseBlips+1] = NewHouseBlip
end)

RegisterNetEvent('NADRP-houses:client:refreshBlips', function() -- Refresh unowned on buy
    for k,v in pairs(UnownedHouseBlips) do RemoveBlip(v) end
    Wait(250)
    TriggerEvent('NADRP-houses:client:setupHouseBlips2')
end)

RegisterNetEvent('NADRP-houses:client:SetClosestHouse', function()
    SetClosestHouse()
end)

RegisterNetEvent('NADRP-houses:client:viewHouse', function(houseprice, brokerfee, bankfee, taxes, firstname, lastname)
    setViewCam(Config.Houses[ClosestHouse].coords.cam, Config.Houses[ClosestHouse].coords.cam.h, Config.Houses[ClosestHouse].coords.yaw)
    Wait(500)
    openContract(true)
    SendNUIMessage({
        type = "setupContract",
        firstname = firstname,
        lastname = lastname,
        street = Config.Houses[ClosestHouse].adress,
        houseprice = houseprice,
        brokerfee = brokerfee,
        bankfee = bankfee,
        taxes = taxes,
        totalprice = (houseprice + brokerfee + bankfee + taxes)
    })
end)

RegisterNetEvent('NADRP-houses:client:setLocation', function(data)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local coords = {x = pos.x, y = pos.y, z = pos.z}
    if IsInside then
        if HasHouseKey then
            if data.id == 'setstash' then
                TriggerServerEvent('NADRP-houses:server:setLocation', coords, ClosestHouse, 1)
            elseif data.id == 'setoutift' then
                TriggerServerEvent('NADRP-houses:server:setLocation', coords, ClosestHouse, 2)
            elseif data.id == 'setlogout' then
                TriggerServerEvent('NADRP-houses:server:setLocation', coords, ClosestHouse, 3)
            end
        else
            NADRP.Functions.Notify(Lang:t("error.not_owner"), "error")
        end
    else
        NADRP.Functions.Notify(Lang:t("error.not_in_house"), "error")
    end
end)

RegisterNetEvent('NADRP-houses:client:refreshLocations', function(house, location, type)
    if ClosestHouse == house then
        if IsInside then
            if type == 1 then
                stashLocation = json.decode(location)
            elseif type == 2 then
                outfitLocation = json.decode(location)
            elseif type == 3 then
                logoutLocation = json.decode(location)
            end
        end
    end
end)

RegisterNetEvent('NADRP-houses:client:HomeInvasion', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local Skillbar = exports['NADRP-skillbar']:GetSkillbarObject()
    if ClosestHouse ~= nil then
        NADRP.Functions.TriggerCallback('police:server:IsPoliceForcePresent', function(IsPresent)
            if IsPresent then
                local dist = #(pos - vector3(Config.Houses[ClosestHouse].coords.enter.x, Config.Houses[ClosestHouse].coords.enter.y, Config.Houses[ClosestHouse].coords.enter.z))
                if Config.Houses[ClosestHouse].IsRaming == nil then
                    Config.Houses[ClosestHouse].IsRaming = false
                end
                if dist < 1 then
                    if Config.Houses[ClosestHouse].locked then
                        if not Config.Houses[ClosestHouse].IsRaming then
                            DoRamAnimation(true)
                            Skillbar.Start({
                                duration = math.random(5000, 10000),
                                pos = math.random(10, 30),
                                width = math.random(10, 20),
                            }, function()
                                if RamsDone + 1 >= Config.RamsNeeded then
                                    TriggerServerEvent('NADRP-houses:server:lockHouse', false, ClosestHouse)
                                    NADRP.Functions.Notify(Lang:t("success.home_invasion"), 'success')
                                    TriggerServerEvent('NADRP-houses:server:SetHouseRammed', true, ClosestHouse)
                                    TriggerServerEvent('NADRP-houses:server:SetRamState', false, ClosestHouse)
                                    DoRamAnimation(false)
                                else
                                    DoRamAnimation(true)
                                    Skillbar.Repeat({
                                        duration = math.random(500, 1000),
                                        pos = math.random(10, 30),
                                        width = math.random(5, 12),
                                    })
                                    RamsDone = RamsDone + 1
                                end
                            end, function()
                                RamsDone = 0
                                TriggerServerEvent('NADRP-houses:server:SetRamState', false, ClosestHouse)
                                NADRP.Functions.Notify(Lang:t("error.failed_invasion"), 'error')
                                DoRamAnimation(false)
                            end)
                            TriggerServerEvent('NADRP-houses:server:SetRamState', true, ClosestHouse)
                        else
                            NADRP.Functions.Notify(Lang:t("error.inprogress_invasion"), 'error')
                        end
                    else
                        NADRP.Functions.Notify(Lang:t("error.already_open"), 'error')
                    end
                else
                    NADRP.Functions.Notify(Lang:t("error.no_house"), "error")
                end
            else
                NADRP.Functions.Notify(Lang:t("error.no_police"), 'error')
            end
        end)
    else
        NADRP.Functions.Notify(Lang:t("error.no_house"), "error")
    end
end)

RegisterNetEvent('NADRP-houses:client:SetRamState', function(bool, house)
    Config.Houses[house].IsRaming = bool
end)

RegisterNetEvent('NADRP-houses:client:SetHouseRammed', function(bool, house)
    Config.Houses[house].IsRammed = bool
end)

RegisterNetEvent('NADRP-houses:client:ResetHouse', function()
    if ClosestHouse ~= nil then
        if Config.Houses[ClosestHouse].IsRammed == nil then
            Config.Houses[ClosestHouse].IsRammed = false
            TriggerServerEvent('NADRP-houses:server:SetHouseRammed', false, ClosestHouse)
            TriggerServerEvent('NADRP-houses:server:SetRamState', false, ClosestHouse)
        end
        if Config.Houses[ClosestHouse].IsRammed then
            openHouseAnim()
            TriggerServerEvent('NADRP-houses:server:SetHouseRammed', false, ClosestHouse)
            TriggerServerEvent('NADRP-houses:server:SetRamState', false, ClosestHouse)
            TriggerServerEvent('NADRP-houses:server:lockHouse', true, ClosestHouse)
            RamsDone = 0
            NADRP.Functions.Notify(Lang:t("success.lock_invasion"), 'success')
        else
            NADRP.Functions.Notify(Lang:t("error.no_invasion"), 'error')
        end
    end
end)

RegisterNetEvent('NADRP-houses:client:ExitOwnedHouse', function()
    local door = vector3(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z)
    if CheckDistance(door, 1.5) then
        LeaveOwnedHouse(CurrentHouse)
    end
end)

RegisterNetEvent('NADRP-houses:client:FrontDoorCam', function()
    local door = vector3(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z)
    if CheckDistance(door, 1.5) then
        FrontDoorCam(Config.Houses[CurrentHouse].coords.enter)
    end
end)

RegisterNetEvent('NADRP-houses:client:AnswerDoorbell', function()
    local door = vector3(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z)
    if CheckDistance(door, 1.5) and CurrentDoorBell ~= 0 then
        TriggerServerEvent("NADRP-houses:server:OpenDoor", CurrentDoorBell, ClosestHouse)
        CurrentDoorBell = 0
    end
end)

RegisterNetEvent('NADRP-houses:client:OpenStash', function()
    local stashLoc = vector3(stashLocation.x, stashLocation.y, stashLocation.z)
    if CheckDistance(stashLoc, 1.5) then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", CurrentHouse)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "StashOpen", 0.4)
        TriggerEvent("inventory:client:SetCurrentStash", CurrentHouse)
    end
end)

RegisterNetEvent('NADRP-houses:client:ChangeCharacter', function()
    local stashLoc = vector3(logoutLocation.x, logoutLocation.y, logoutLocation.z)
    if CheckDistance(stashLoc, 1.5) then
        DoScreenFadeOut(250)
        while not IsScreenFadedOut() do
            Wait(10)
        end
        exports['NADRP-interior']:DespawnInterior(houseObj, function()
            TriggerEvent('NADRP-weathersync:client:EnableSync')
            SetEntityCoords(PlayerPedId(), Config.Houses[CurrentHouse].coords.enter.x, Config.Houses[CurrentHouse].coords.enter.y, Config.Houses[CurrentHouse].coords.enter.z + 0.5)
            SetEntityHeading(PlayerPedId(), Config.Houses[CurrentHouse].coords.enter.h)
            InOwnedHouse = false
            IsInside = false
            TriggerServerEvent('NADRP-houses:server:LogoutLocation')
        end)
    end
end)

RegisterNetEvent('NADRP-houses:client:ChangeOutfit', function()
    local outfitLoc = vector3(outfitLocation.x, outfitLocation.y, outfitLocation.z)
    if CheckDistance(outfitLoc, 1.5) then
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "Clothes1", 0.4)
        TriggerEvent('NADRP-clothing:client:openOutfitMenu')
    end
end)

RegisterNetEvent('NADRP-houses:client:ViewHouse', function()
    local houseCoords = vector3(Config.Houses[ClosestHouse].coords.enter.x, Config.Houses[ClosestHouse].coords.enter.y, Config.Houses[ClosestHouse].coords.enter.z)
    if CheckDistance(houseCoords, 1.5) then
        TriggerServerEvent('NADRP-houses:server:viewHouse', ClosestHouse)
    end
end)

RegisterNetEvent('NADRP-houses:client:KeyholderOptions', function(data)
    optionMenu(data.citizenData)
end)
-- NUI Callbacks

RegisterNUICallback('HasEnoughMoney', function(data, cb)
    NADRP.Functions.TriggerCallback('NADRP-houses:server:HasEnoughMoney', function(hasEnough)
    end, data.objectData)
end)

RegisterNUICallback('buy', function()
    openContract(false)
    disableViewCam()
    Config.Houses[ClosestHouse].owned = true
    if Config.UnownedBlips then TriggerEvent('NADRP-houses:client:refreshBlips') end
    TriggerServerEvent('NADRP-houses:server:buyHouse', ClosestHouse)
end)

RegisterNUICallback('exit', function()
    openContract(false)
    disableViewCam()
end)

-- Threads

CreateThread(function()
    Wait(1000)
    TriggerServerEvent('NADRP-houses:server:setHouses')
    SetClosestHouse()
    TriggerEvent('NADRP-houses:client:setupHouseBlips')
    if Config.UnownedBlips then TriggerEvent('NADRP-houses:client:setupHouseBlips2') end
    Wait(100)
    TriggerEvent('NADRP-garages:client:setHouseGarage', ClosestHouse, HasHouseKey)
    TriggerServerEvent("NADRP-houses:server:setHouses")
end)

CreateThread(function()
    while true do
        Wait(5000)
        if LocalPlayer.state['isLoggedIn'] then
            if not IsInside then
                SetClosestHouse()
            end
        end
    end
end)

CreateThread(function()
    local shownMenu = false

    while true do
        local pos = GetEntityCoords(PlayerPedId())
        local inRange = false
        local nearLocation = false
        local houseMenu = {}

        if ClosestHouse ~= nil then
            local dist2 = vector3(Config.Houses[ClosestHouse].coords.enter.x, Config.Houses[ClosestHouse].coords.enter.y, Config.Houses[ClosestHouse].coords.enter.z)
            if #(pos.xy - dist2.xy) < 30 then
                inRange = true
                if HasHouseKey then
                    -- ENTER HOUSE

                    if not IsInside then
                        if ClosestHouse ~= nil then
                            if #(pos - dist2) <= 1.5 then
                                houseMenu = {
                                    {
                                        header = Lang:t("menu.house_options"),
                                        isMenuHeader = true, -- Set to true to make a nonclickable title
                                    },
                                    {
                                        header = Lang:t("menu.enter_house"),
                                        params = {
                                            event = "NADRP-houses:client:EnterHouse",

                                        }
                                    },
                                    {
                                        header = Lang:t("menu.give_house_key"),
                                        params = {
                                            event = "NADRP-houses:client:giveHouseKey",
                                        }
                                    }
                                }
                                nearLocation = true
                            end
                        end
                    else
                        if not entering and POIOffsets ~= nil then
                            local exitOffset = vector3(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z + 1.0)
                            if #(pos - exitOffset) <= 1.5 then
                                houseMenu = {
                                    {
                                        header = Lang:t("menu.exit_property"),
                                        params = {
                                            event = 'NADRP-houses:client:ExitOwnedHouse',
                                            args = {}
                                        }
                                    },
                                    {
                                        header = Lang:t("menu.front_camera"),
                                        params = {
                                            event = 'NADRP-houses:client:FrontDoorCam',
                                            args = {}
                                        }
                                    }
                                }

                                if CurrentDoorBell ~= 0 then
                                    houseMenu[#houseMenu+1] = {
                                        header = Lang:t("menu.open_door"),
                                        params = {
                                            event = 'NADRP-houses:client:AnswerDoorbell',
                                            args = {}
                                        }
                                    }
                                end
                                nearLocation = true
                            end
                        end
                    end
                else

                    if ClosestHouse ~= nil and not IsInside  then
                        if not isOwned then
                            local houseCoords = vector3(Config.Houses[ClosestHouse].coords.enter.x, Config.Houses[ClosestHouse].coords.enter.y, Config.Houses[ClosestHouse].coords.enter.z)
                            if #(pos - houseCoords) <= 1.5 then
                                if not viewCam and Config.Houses[ClosestHouse].locked then
                                    houseMenu = {
                                        {
                                            header = Lang:t("menu.view_house"),
                                            params = {
                                                event = 'NADRP-houses:client:ViewHouse',
                                                args = {}
                                            }
                                        }
                                    }
                                    nearLocation = true
                                end
                            end
                        end

                        if isOwned then
                            local houseCoords = vector3(Config.Houses[ClosestHouse].coords.enter.x, Config.Houses[ClosestHouse].coords.enter.y, Config.Houses[ClosestHouse].coords.enter.z)
                            if #(pos - houseCoords) <= 1.5 then
                                nearLocation = true
                                houseMenu = {
                                    {
                                        header = Lang:t("menu.ring_door"),
                                        params = {
                                            event = 'NADRP-houses:client:RequestRing',
                                            args = {}
                                        }
                                    }
                                }
                                if not Config.Houses[ClosestHouse].locked then
                                    houseMenu[#houseMenu+1] = {
                                        header = Lang:t("menu.enter_unlocked_house"),
                                        params = {
                                            event = "NADRP-houses:client:EnterHouse",
                                        }
                                    }
                                    if NADRP.Functions.GetPlayerData().job.name == 'police' then
                                        houseMenu[#houseMenu+1] = {
                                            header = Lang:t("menu.lock_door_police"),
                                            params = {
                                                event = "NADRP-houses:client:ResetHouse",
                                            }
                                        }
                                    end
                                end
                            end
                        end
                    end

                    if IsInside and CurrentHouse ~= nil and not entering then
                        if POIOffsets ~= nil then
                            local exitOffset = vector3(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z + 1.0)
                            if #(pos - exitOffset) <= 1.5 then
                                houseMenu = {
                                    {
                                        header = Lang:t("menu.exit_door"),
                                        params = {
                                            event = 'NADRP-houses:client:ExitOwnedHouse',
                                            args = {}
                                        }
                                    }
                                }
                                nearLocation = true
                            end
                        end
                    end
                end

                if IsInside and CurrentHouse ~= nil and not entering and isOwned then
                    if stashLocation ~= nil then
                        if #(pos - vector3(stashLocation.x, stashLocation.y, stashLocation.z)) <= 1.5 then
                            nearLocation = true
                            houseMenu = {
                                {
                                    header = Lang:t("menu.open_stash"),
                                    params = {
                                        event = "NADRP-houses:client:OpenStash",
                                        args = {}
                                    }
                                }
                            }

                        elseif #(pos - vector3(stashLocation.x, stashLocation.y, stashLocation.z)) <= 3 then
                            DrawText3Ds(stashLocation.x, stashLocation.y, stashLocation.z, Lang:t("menu.stash"))
                        end
                    end

                    if outfitLocation ~= nil then
                        if #(pos - vector3(outfitLocation.x, outfitLocation.y, outfitLocation.z)) <= 1.5 then
                            nearLocation = true
                            houseMenu = {
                                {
                                    header = Lang:t("menu.change_outfit"),
                                    params = {
                                        event = "NADRP-houses:client:ChangeOutfit",
                                        args = {}
                                    }
                                }
                            }
                        elseif #(pos - vector3(outfitLocation.x, outfitLocation.y, outfitLocation.z)) <= 3 then
                            DrawText3Ds(outfitLocation.x, outfitLocation.y, outfitLocation.z, Lang:t("menu.outfits"))
                        end
                    end

                    if logoutLocation ~= nil then
                        if #(pos - vector3(logoutLocation.x, logoutLocation.y, logoutLocation.z)) <= 1.5 then
                            nearLocation = true
                            houseMenu = {
                                {
                                    header = Lang:t("menu.change_character"),
                                    params = {
                                        event = "NADRP-houses:client:ChangeCharacter",
                                        args = {}
                                    }
                                }
                            }
                        elseif #(pos - vector3(logoutLocation.x, logoutLocation.y, logoutLocation.z)) < 3 then
                            DrawText3Ds(logoutLocation.x, logoutLocation.y, logoutLocation.z, Lang:t("menu.characters"))
                        end
                    end
                end

                if nearLocation and not shownMenu then
                    exports['NADRP-menu']:showHeader(houseMenu)
                    shownMenu = true
                end

                if not nearLocation and shownMenu then
                    CloseMenuFull()
                    shownMenu = false
                end
            end
        end

        if not inRange then
            Wait(1500)

            if shownMenu then
                CloseMenuFull()
                shownMenu = false
            end
        end
        Wait(3)
    end
end)

RegisterCommand('getoffset', function()
    local coords = GetEntityCoords(PlayerPedId())
    local houseCoords = vector3(
        Config.Houses[CurrentHouse].coords.enter.x,
        Config.Houses[CurrentHouse].coords.enter.y,
        Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset
    )
    if IsInside then
        local xdist = coords.x - houseCoords.x
        local ydist = coords.y - houseCoords.y
        local zdist = coords.z - houseCoords.z
        print('X: '..xdist)
        print('Y: '..ydist)
        print('Z: '..zdist)
    end
end)
