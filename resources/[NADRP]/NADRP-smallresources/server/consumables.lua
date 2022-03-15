NADRP = exports['NADRP-core']:GetCoreObject()

----------- / alcohol

NADRP.Functions.CreateUseableItem("vodka", function(source, item)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
    TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name)
end)

NADRP.Functions.CreateUseableItem("beer", function(source, item)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
    TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name)
end)

NADRP.Functions.CreateUseableItem("whiskey", function(source, item)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
    TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name)
end)

----------- / Eat

NADRP.Functions.CreateUseableItem("sandwich", function(source, item)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", src, item.name)
    end
end)

NADRP.Functions.CreateUseableItem("twerks_candy", function(source, item)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", src, item.name)
    end
end)

NADRP.Functions.CreateUseableItem("snikkel_candy", function(source, item)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", src, item.name)
    end
end)

NADRP.Functions.CreateUseableItem("tosti", function(source, item)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", src, item.name)
    end
end)

----------- / Drink

NADRP.Functions.CreateUseableItem("water_bottle", function(source, item)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", src, item.name)
    end
end)

NADRP.Functions.CreateUseableItem("coffee", function(source, item)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", src, item.name)
    end
end)

NADRP.Functions.CreateUseableItem("kurkakola", function(source, item)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", src, item.name)
    end
end)

----------- / Drug

NADRP.Functions.CreateUseableItem("joint", function(source, item)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:UseJoint", src)
    end
end)

NADRP.Functions.CreateUseableItem("cokebaggy", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:Cokebaggy", src)
end)

NADRP.Functions.CreateUseableItem("crack_baggy", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:Crackbaggy", src)
end)

NADRP.Functions.CreateUseableItem("xtcbaggy", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:EcstasyBaggy", src)
end)

NADRP.Functions.CreateUseableItem("oxy", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:oxy", src)
end)

NADRP.Functions.CreateUseableItem("meth", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:meth", src)
end)

----------- / Tools

NADRP.Functions.CreateUseableItem("armor", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:UseArmor", src)
end)

NADRP.Functions.CreateUseableItem("heavyarmor", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:UseHeavyArmor", src)
end)

NADRP.Commands.Add("resetarmor", "Resets Vest (Police Only)", {}, false, function(source, args)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("consumables:client:ResetArmor", src)
    else
        TriggerClientEvent('NADRP:Notify', src,  "For Police Officer Only", "error")
    end
end)

NADRP.Functions.CreateUseableItem("binoculars", function(source, item)
    local src = source
    TriggerClientEvent("binoculars:Toggle", src)
end)

NADRP.Functions.CreateUseableItem("parachute", function(source, item)
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:UseParachute", src)
    end
end)

NADRP.Commands.Add("resetparachute", "Resets Parachute", {}, false, function(source, args)
    local src = source
	TriggerClientEvent("consumables:client:ResetParachute", src)
end)

RegisterNetEvent('NADRP-smallpenis:server:AddParachute', function()
    local src = source
    local Player = NADRP.Functions.GetPlayer(src)
    Player.Functions.AddItem("parachute", 1)
end)

----------- / Firework

NADRP.Functions.CreateUseableItem("firework1", function(source, item)
    local src = source
    TriggerClientEvent("fireworks:client:UseFirework", src, item.name, "proj_indep_firework")
end)

NADRP.Functions.CreateUseableItem("firework2", function(source, item)
    local src = source
    TriggerClientEvent("fireworks:client:UseFirework", src, item.name, "proj_indep_firework_v2")
end)

NADRP.Functions.CreateUseableItem("firework3", function(source, item)
    local src = source
    TriggerClientEvent("fireworks:client:UseFirework", src, item.name, "proj_xmas_firework")
end)

NADRP.Functions.CreateUseableItem("firework4", function(source, item)
    local src = source
    TriggerClientEvent("fireworks:client:UseFirework", src, item.name, "scr_indep_fireworks")
end)

----------- / Lockpicking

NADRP.Functions.CreateUseableItem("lockpick", function(source, item)
    local Player = NADRP.Functions.GetPlayer(source)
    TriggerClientEvent("lockpicks:UseLockpick", source, false)
end)

NADRP.Functions.CreateUseableItem("advancedlockpick", function(source, item)
    local Player = NADRP.Functions.GetPlayer(source)
    TriggerClientEvent("lockpicks:UseLockpick", source, true)
end)

----------- / Unused

-- NADRP.Functions.CreateUseableItem("smoketrailred", function(source, item)
--     local Player = NADRP.Functions.GetPlayer(source)
-- 	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
--         TriggerClientEvent("consumables:client:UseRedSmoke", source)
--     end
-- end)
