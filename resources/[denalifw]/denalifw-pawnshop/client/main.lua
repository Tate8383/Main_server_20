local DenaliFW = exports['denalifw-core']:GetCoreObject()
local isMelting = false
local canTake = false
local inRange = false
local headerOpen = false
local meltTime

CreateThread(function()
	local blip = AddBlipForCoord(Config.PawnLocation.x, Config.PawnLocation.y, Config.PawnLocation.z)
	SetBlipSprite(blip, 431)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 5)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(Lang:t("info.title"))
	EndTextCommandSetBlipName(blip)
end)

CreateThread(function()
	while true do
		Wait(500)
		local pos = GetEntityCoords(PlayerPedId())
		if #(pos - Config.PawnLocation) < 1.5 then
			inRange = true
		else
			inRange = false
		end
		if inRange and not headerOpen then
			headerOpen = true
			exports['denalifw-menu']:showHeader({
				{
					header = Lang:t('info.title'),
					txt = Lang:t('info.open_pawn'),
					params = {
						event = "denalifw-pawnshop:client:openMenu"
					}
				}
			})
		end
		if not inRange and headerOpen then
			headerOpen = false
			exports['denalifw-menu']:closeMenu()
		end
    end
end)

RegisterNetEvent('denalifw-pawnshop:client:openMenu', function()
	if Config.UseTimes then
		if GetClockHours() >= Config.TimeOpen and GetClockHours() <= Config.TimeClosed then
			local pawnShop = {
				{
					header = Lang:t('info.title'),
					isMenuHeader = true,
				},
				{
					header = Lang:t('info.sell'),
					txt = Lang:t('info.sell_pawn'),
					params = {
						event = "denalifw-pawnshop:client:openPawn",
						args = {
							items = Config.PawnItems
						}
					}
				}
			}

			if not isMelting then
				pawnShop[#pawnShop + 1] = {
					header = Lang:t('info.melt'),
					txt = Lang:t('info.melt_pawn'),
					params = {
						event = "denalifw-pawnshop:client:openMelt",
						args = {
							items = Config.MeltingItems
						}
					}
				}
			end

			if canTake then
				pawnShop[#pawnShop + 1] = {
					header = Lang:t('info.melt_pickup'),
					txt = "",
					params = {
						isServer = true,
						event = "denalifw-pawnshop:server:pickupMelted",
						args = {
							items = meltedItem
						}
					}
				}
			end
			exports['denalifw-menu']:openMenu(pawnShop)
		else
			DenaliFW.Functions.Notify(Lang:t('info.pawn_closed', {value = Config.TimeOpen, value2 = Config.TimeClosed}))
		end
	else
		local pawnShop = {
			{
				header = Lang:t('info.title'),
				isMenuHeader = true,
			},
			{
				header = Lang:t('info.sell'),
				txt = Lang:t('info.sell_pawn'),
				params = {
					event = "denalifw-pawnshop:client:openPawn",
					args = {
						items = Config.PawnItems
					}
				}
			}
		}

		if not isMelting then
			pawnShop[#pawnShop + 1] = {
				header = Lang:t('info.melt'),
				txt = Lang:t('info.melt_pawn'),
				params = {
					event = "denalifw-pawnshop:client:openMelt",
					args = {
						items = Config.MeltingItems
					}
				}
			}
		end

		if canTake then
			pawnShop[#pawnShop + 1] = {
				header = Lang:t('info.melt_pickup'),
				txt = "",
				params = {
					isServer = true,
					event = "denalifw-pawnshop:server:pickupMelted",
					args = {
						items = meltedItem
					}
				}
			}
		end
		exports['denalifw-menu']:openMenu(pawnShop)
	end
end)

RegisterNetEvent('denalifw-pawnshop:client:openPawn', function(data)
	DenaliFW.Functions.TriggerCallback('denalifw-pawnshop:server:getInv', function(inventory)
		local PlyInv = inventory
		local pawnMenu = {
			{
				header = Lang:t('info.title'),
				isMenuHeader = true,
			}
		}

		for k,v in pairs(PlyInv) do
			for i = 1, #data.items do
				if v.name == data.items[i].item then
					pawnMenu[#pawnMenu +1] = {
						header = DenaliFW.Shared.Items[v.name].label,
						txt = Lang:t('info.sell_items', {value = data.items[i].price}),
						params = {
							event = "denalifw-pawnshop:client:pawnitems",
							args = {
								label = DenaliFW.Shared.Items[v.name].label,
								price = data.items[i].price,
								name = v.name,
								amount = v.amount
							}
						}
					}
				end
			end
		end

		pawnMenu[#pawnMenu+1] = {
			header = Lang:t('info.back'),
			params = {
				event = "denalifw-pawnshop:client:openMenu"
			}
		}
		exports['denalifw-menu']:openMenu(pawnMenu)
	end)
end)

RegisterNetEvent('denalifw-pawnshop:client:openMelt', function(data)
	DenaliFW.Functions.TriggerCallback('denalifw-pawnshop:server:getInv', function(inventory)
		local PlyInv = inventory
		local meltMenu = {
			{
				header = Lang:t('info.melt'),
				isMenuHeader = true,
			}
		}
		for k,v in pairs(PlyInv) do
			for i = 1, #data.items do
				if v.name == data.items[i].item then
					meltMenu[#meltMenu +1] = {
						header = DenaliFW.Shared.Items[v.name].label,
						txt = Lang:t('info.melt_item', {value = DenaliFW.Shared.Items[v.name].label}),
						params = {
							event = "denalifw-pawnshop:client:meltItems",
							args = {
								label = DenaliFW.Shared.Items[v.name].label,
								reward = data.items[i].rewards,
								name = v.name,
								amount = v.amount,
								time = data.items[i].meltTime
							}
						}
					}
				end
			end
		end

		meltMenu[#meltMenu+1] = {
			header = Lang:t('info.back'),
			params = {
				event = "denalifw-pawnshop:client:openMenu"
			}
		}
		exports['denalifw-menu']:openMenu(meltMenu)
	end)
end)

RegisterNetEvent("denalifw-pawnshop:client:pawnitems", function(item)
	local sellingItem = exports['denalifw-input']:ShowInput({
		header = Lang:t('info.title'),
		submitText = Lang:t('info.sell'),
		inputs = {
			{
				type = 'number',
				isRequired = false,
				name = 'amount',
				text = Lang:t('info.max', {value = item.amount})
			}
		}
	})

	if sellingItem then
		if not sellingItem.amount then
			return
		end

		if tonumber(sellingItem.amount) > 0 then
			TriggerServerEvent('denalifw-pawnshop:server:sellPawnItems', item.name, sellingItem.amount, item.price)
		else
			DenaliFW.Functions.Notify(Lang:t('error.negative'), 'error')
		end
	end
end)

RegisterNetEvent('denalifw-pawnshop:client:meltItems', function(item)
	local meltingItem = exports['denalifw-input']:ShowInput({
		header = Lang:t('info.melt'),
		submitText = Lang:t('info.submit'),
		inputs = {
			{
				type = 'number',
				isRequired = false,
				name = 'amount',
				text = Lang:t('info.max', {value = item.amount})
			}
		}
	})

	if meltingItem then
		if not meltingItem.amount then
			return
		end
		if meltingItem.amount ~= nil then
			if tonumber(meltingItem.amount) > 0 then
				TriggerServerEvent('denalifw-pawnshop:server:meltItemRemove', item.name, meltingItem.amount,item)

			else
				DenaliFW.Functions.Notify(Lang:t('error.no_melt'), "error")
			end
		else
			DenaliFW.Functions.Notify(Lang:t('error.no_melt'), "error")
		end
	end
end)

RegisterNetEvent('denalifw-pawnshop:client:startMelting', function(item, meltingAmount, meltTimees)
    if not isMelting then
        isMelting = true
		meltTime = meltTimees
		meltedItem = {}

        CreateThread(function()
            while isMelting do
                if LocalPlayer.state.isLoggedIn then
                    meltTime = meltTime - 1
                    if meltTime <= 0 then
                        canTake = true
                        isMelting = false
						table.insert(meltedItem, {item = item, amount = meltingAmount})
						if Config.SendMeltingEmail then
							TriggerServerEvent('denalifw-phone:server:sendNewMail', {
								sender = Lang:t('info.title'),
								subject = Lang:t('info.subject'),
								message = Lang:t('info.message'),
								button = {}
							})
						else
							DenaliFW.Functions.Notify(Lang:t('info.message'), "success")
						end
                    end
                else
                    break
                end
                Wait(1000)
            end
        end)
    end
end)

RegisterNetEvent('denalifw-pawnshop:client:resetPickup', function()
	canTake = false
end)