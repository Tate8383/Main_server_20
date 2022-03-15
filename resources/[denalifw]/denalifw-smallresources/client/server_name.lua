function SetData()
	players = {}
	for _, player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)
		table.insert( players, player )
end

	
	local name = GetPlayerName(PlayerId())
	local id = GetPlayerServerId(PlayerId())
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), 'FE_THDR_GTAO', "~q~Denali Custom FW~s~  | ID: "..id.." | ~r~".. #players .." connected")
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		SetData()
	end
end)

Citizen.CreateThread(function()
    AddTextEntry("PM_PANE_LEAVE", "~r~Sign out ~p~Denali Custom FW 😭")
end)

Citizen.CreateThread(function()
    AddTextEntry("PM_PANE_QUIT", "~r~leave ~o~FiveM🐌")
end)

Citizen.CreateThread(function()
	AddTextEntry("PM_SCR_MAP", "~o~Map")
end)

Citizen.CreateThread(function()
	AddTextEntry("PM_SCR_GAM", "~r~Take the plane")
end)

Citizen.CreateThread(function()
	AddTextEntry("PM_SCR_INF", "~g~Logs")
end)

Citizen.CreateThread(function()
	AddTextEntry("PM_SCR_SET", "~q~Configuration")
end)

Citizen.CreateThread(function()
	AddTextEntry("PM_SCR_STA", "~p~Statistics")
end)

Citizen.CreateThread(function()
	AddTextEntry("PM_SCR_GAL", "~b~Gallery")
end)

Citizen.CreateThread(function()
	AddTextEntry("PM_SCR_RPL", "~c~Editor ∑")
end)

---------------------------------
--- Copyright by Mayank43#3146 ---
---------------------------------