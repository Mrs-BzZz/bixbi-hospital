ESX = nil 
local PlayerData              = {}

Citizen.CreateThread(function() 
	while ESX == nil do 
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
		Citizen.Wait(1) 
	end 
		PlayerData = ESX.GetPlayerData() 
end) 

local hosDuration = 0
local location = nil
-- Citizen.CreateThread(function()
-- 	while true do
-- 		Wait(1000)
-- 		if location ~= nil and hosDuration > 0 then
-- 			hosDuration = hosDuration - 1

-- 			local playerPed = GetPlayerPed(-1)
-- 			local playerLocation = GetEntityCoords(playerPed, true)
-- 			local distance = Vdist(location.incoords[1], location.incoords[2], location.incoords[3], playerLocation['x'], playerLocation['y'], playerLocation['z'])
		
-- 			if distance > 20 and Config.CheckDistance == true then
-- 				SetEntityCoords(playerPed, location.incoords[1], location.incoords[2], location.incoords[3])
-- 				hosDuration = hosDuration + 30 -- 30 seconds.
-- 				if hosDuration > Config.MaxTime then
-- 					hosDuration = Config.MaxTime
-- 				end
-- 				TriggerEvent('chatMessage', '[EMS]', { 0, 128, 255 }, " your hospital stay time was extended as you were not officially discharged.")
-- 				TriggerEvent('chatMessage', '[EMS]', { 0, 128, 255 }, ' You have ' .. hosDuration .. ' seconds left in hospital.')
				
-- 				TriggerEvent('bixbi_hospital:notify', '', "Your hospital stay time was extended as you were not officially discharged.")
-- 				TriggerEvent('bixbi_hospital:notify', '', 'You have ' .. hosDuration .. ' seconds left in hospital.')
-- 			end

-- 			if hosDuration == 10 or hosDuration == 30 or hosDuration == 60 or hosDuration == 120 or hosDuration == 300 then
-- 				TriggerEvent('bixbi_hospital:notify', '', 'You have ' .. hosDuration .. ' seconds left in hospital.')
-- 				TriggerEvent('chatMessage', '[EMS]', { 0, 128, 255 }, ' You have ' .. hosDuration .. ' seconds left in hospital.')
-- 			end
-- 		elseif location ~= nil then
-- 			TriggerEvent("bixbi_hospital:release")
-- 		end
-- 	end
-- end)

function thread()
	if location ~= nil then
		if hosDuration > 0 then
			hosDuration = hosDuration - 1
			
			local playerPed = PlayerPedId()
			local playerPos = GetEntityCoords(playerPed)
			local distance = #(playerPos - location.incoords)
			
			if distance > 20 and Config.CheckDistance then
				SetEntityCoords(playerPed, location.incoords[1], location.incoords[2], location.incoords[3])
				hosDuration = hosDuration + 30 -- 30 seconds.
				if hosDuration > Config.MaxTime then
					hosDuration = Config.MaxTime
				end
				TriggerEvent('chatMessage', '[EMS]', { 0, 128, 255 }, " your hospital stay time was extended as you were not officially discharged.")
				TriggerEvent('chatMessage', '[EMS]', { 0, 128, 255 }, ' You have ' .. hosDuration .. ' seconds left in hospital.')
				
				TriggerEvent('bixbi_hospital:notify', '', "Your hospital stay time was extended as you were not officially discharged.")
				TriggerEvent('bixbi_hospital:notify', '', 'You have ' .. hosDuration .. ' seconds left in hospital.')
			end

			if hosDuration == 10 or hosDuration == 30 or hosDuration == 60 or hosDuration == 120 or hosDuration == 300 then
				TriggerEvent('bixbi_hospital:notify', '', 'You have ' .. hosDuration .. ' seconds left in hospital.')
				TriggerEvent('chatMessage', '[EMS]', { 0, 128, 255 }, ' You have ' .. hosDuration .. ' seconds left in hospital.')
			end
		elseif location ~= nil then
			TriggerEvent("bixbi_hospital:release")
		end
	end

	SetTimeout(1000, thread)
end

thread()

RegisterNetEvent("bixbi_hospital:send")
AddEventHandler("bixbi_hospital:send", function(duration, inputLocation)
	local loc = Config.Locations[inputLocation:upper()]
	if loc ~= nil then
		local playerPed = GetPlayerPed(-1)
		if DoesEntityExist(playerPed) then
			
			DoScreenFadeOut(2000)
			Citizen.Wait(2000)

			location = loc
			hosDuration = duration

			SetEntityCoords(playerPed, loc.incoords[1], loc.incoords[2], loc.incoords[3])
			RemoveAllPedWeapons(playerPed, true)
			if IsPedInAnyVehicle(playerPed, false) then
				ClearPedTasksImmediately(playerPed)
			end
			
			TriggerEvent('bixbi_hospital:notify', '', 'You have been sent to ' .. loc.label .. ' for ' .. duration .. ' seconds.')
			TriggerEvent('chatMessage', '[EMS]', { 0, 128, 255 }, ' You have been sent to ' .. loc.label .. ' for ' .. duration .. ' seconds.')
		
			Citizen.Wait(1500)
			DoScreenFadeIn(2000)
			if Config.CheckDistance == false then
				TriggerEvent("bixbi_hospital:loading", duration * 1000, 'You are being observed by the medical team.')
			else
				TriggerEvent("bixbi_hospital:loading", 3000, 'Welcome to ' .. loc.label .. '.')
			end
		end
	else
		hosDuration = 0
		location = {}
	end
end)

RegisterNetEvent("bixbi_hospital:release")
AddEventHandler("bixbi_hospital:release", function()
	local playerPed = GetPlayerPed(-1)
	SetEntityCoords(playerPed, location.outcoords[1], location.outcoords[2], location.outcoords[3])

	TriggerEvent('bixbi_hospital:notify', '', 'You have been released from ' .. location.label .. '.')
	TriggerEvent('chatMessage', '[EMS]', { 0, 128, 255 }, ' You have been released from ' .. location.label .. '.')

	hosDuration = 0
	location = nil
end)