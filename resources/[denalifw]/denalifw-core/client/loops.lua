CreateThread(function()
    while true do
        Wait(0)
        if LocalPlayer.state.isLoggedIn then
            Wait((1000 * 60) * DenaliFW.Config.UpdateInterval)
            TriggerServerEvent('DenaliFW:UpdatePlayer')
        end
    end
end)

CreateThread(function()
    while true do
        Wait(DenaliFW.Config.StatusInterval)
        if LocalPlayer.state.isLoggedIn then
            if DenaliFW.Functions.GetPlayerData().metadata['hunger'] <= 0 or
                    DenaliFW.Functions.GetPlayerData().metadata['thirst'] <= 0 then
                local ped = PlayerPedId()
                local currentHealth = GetEntityHealth(ped)
                SetEntityHealth(ped, currentHealth - math.random(5, 10))
            end
        end
    end
end)
