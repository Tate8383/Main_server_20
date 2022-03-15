DenaliFW = exports['denalifw-core']:GetCoreObject()

----------- / alcohol

DenaliFW.Functions.CreateUseableItem("vodka", function(source, item)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name)
end)

DenaliFW.Functions.CreateUseableItem("beer", function(source, item)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name)
end)

DenaliFW.Functions.CreateUseableItem("whiskey", function(source, item)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name)
end)

----------- / Eat

DenaliFW.Functions.CreateUseableItem("sandwich", function(source, item)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", src, item.name)
    end
end)

DenaliFW.Functions.CreateUseableItem("twerks_candy", function(source, item)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", src, item.name)
    end
end)

DenaliFW.Functions.CreateUseableItem("snikkel_candy", function(source, item)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", src, item.name)
    end
end)

DenaliFW.Functions.CreateUseableItem("tosti", function(source, item)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", src, item.name)
    end
end)

----------- / Drink

DenaliFW.Functions.CreateUseableItem("water_bottle", function(source, item)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", src, item.name)
    end
end)

DenaliFW.Functions.CreateUseableItem("coffee", function(source, item)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", src, item.name)
    end
end)

DenaliFW.Functions.CreateUseableItem("kurkakola", function(source, item)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", src, item.name)
    end
end)

----------- / Drug

DenaliFW.Functions.CreateUseableItem("joint", function(source, item)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:UseJoint", src)
    end
end)

DenaliFW.Functions.CreateUseableItem("cokebaggy", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:Cokebaggy", src)
end)

DenaliFW.Functions.CreateUseableItem("crack_baggy", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:Crackbaggy", src)
end)

DenaliFW.Functions.CreateUseableItem("xtcbaggy", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:EcstasyBaggy", src)
end)

DenaliFW.Functions.CreateUseableItem("oxy", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:oxy", src)
end)

DenaliFW.Functions.CreateUseableItem("meth", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:meth", src)
end)

----------- / Tools

DenaliFW.Functions.CreateUseableItem("armor", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:UseArmor", src)
end)

DenaliFW.Functions.CreateUseableItem("heavyarmor", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:UseHeavyArmor", src)
end)

DenaliFW.Commands.Add("resetarmor", "Resets Vest (Police Only)", {}, false, function(source, args)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("consumables:client:ResetArmor", src)
    else
        TriggerClientEvent('DenaliFW:Notify', src,  "For Police Officer Only", "error")
    end
end)

DenaliFW.Functions.CreateUseableItem("binoculars", function(source, item)
    local src = source
    TriggerClientEvent("binoculars:Toggle", src)
end)

DenaliFW.Functions.CreateUseableItem("parachute", function(source, item)
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:UseParachute", src)
    end
end)

DenaliFW.Commands.Add("resetparachute", "Resets Parachute", {}, false, function(source, args)
    local src = source
	TriggerClientEvent("consumables:client:ResetParachute", src)
end)

RegisterNetEvent('denalifw-smallpenis:server:AddParachute', function()
    local src = source
    local Player = DenaliFW.Functions.GetPlayer(src)
    Player.Functions.AddItem("parachute", 1)
end)

----------- / Firework

DenaliFW.Functions.CreateUseableItem("firework1", function(source, item)
    local src = source
    TriggerClientEvent("fireworks:client:UseFirework", src, item.name, "proj_indep_firework")
end)

DenaliFW.Functions.CreateUseableItem("firework2", function(source, item)
    local src = source
    TriggerClientEvent("fireworks:client:UseFirework", src, item.name, "proj_indep_firework_v2")
end)

DenaliFW.Functions.CreateUseableItem("firework3", function(source, item)
    local src = source
    TriggerClientEvent("fireworks:client:UseFirework", src, item.name, "proj_xmas_firework")
end)

DenaliFW.Functions.CreateUseableItem("firework4", function(source, item)
    local src = source
    TriggerClientEvent("fireworks:client:UseFirework", src, item.name, "scr_indep_fireworks")
end)

----------- / Lockpicking

DenaliFW.Functions.CreateUseableItem("lockpick", function(source, item)
    local Player = DenaliFW.Functions.GetPlayer(source)
    TriggerClientEvent("lockpicks:UseLockpick", source, false)
end)

DenaliFW.Functions.CreateUseableItem("advancedlockpick", function(source, item)
    local Player = DenaliFW.Functions.GetPlayer(source)
    TriggerClientEvent("lockpicks:UseLockpick", source, true)
end)

----------- / Unused

-- DenaliFW.Functions.CreateUseableItem("smoketrailred", function(source, item)
--     local Player = DenaliFW.Functions.GetPlayer(source)
-- 	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
--         TriggerClientEvent("consumables:client:UseRedSmoke", source)
--     end
-- end)
