CreateThread(function()
    while true do
        Wait(0)
        if LocalPlayer.state.isLoggedIn then
            Wait((1000 * 60) * NADRP.Config.UpdateInterval)
            TriggerServerEvent('NADRP:UpdatePlayer')
        end
    end
end)

CreateThread(function()
    while true do
        Wait(NADRP.Config.StatusInterval)
        if LocalPlayer.state.isLoggedIn then
            if NADRP.Functions.GetPlayerData().metadata['hunger'] <= 0 or
                    NADRP.Functions.GetPlayerData().metadata['thirst'] <= 0 then
                local ped = PlayerPedId()
                local currentHealth = GetEntityHealth(ped)
                SetEntityHealth(ped, currentHealth - math.random(5, 10))
            end
        end
    end
end)
