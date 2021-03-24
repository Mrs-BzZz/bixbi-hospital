Config = {}

Config.MaxTime = 600 -- 10 Minutes (600 seconds)
Config.NotifyType = "esx" -- Options = t-notify, esx, feedm, mythic_notify
Config.LoadingType = "mythic" -- Options = mythic, pogress, none
Config.CheckDistance = true -- When true, going too far from the teleport point will teleport the player back, and add time.

Config.Locations = {
	P = { -- Label for sending to a specific hospital. Can change the default in the server file.
		label = "Pillbox Hospital",
		incoords = {336.4747, -574.0878, 35.2109}, -- Where you are teleported to when being sent.
		outcoords = {325.3977, -583.0153, 35.2109} -- Where you will be teleported to after the time ends.
	},
	B = {
		label = "Paleto Bay Hospital",
		incoords = {-255.59, 6311.59, 32.46},
		outcoords = {-234.8, 6317.44, 31.5}
	},
	S = {
		label = "Sandy Shores Hospital",
		incoords = {1821.23, 3674.59, 34.29},
		outcoords = {1841.54, 3668.97, 33.68}
	}
}

RegisterNetEvent('bixbi_hospital:notify')
AddEventHandler("bixbi_hospital:notify", function(type, msg)

	if Config.NotifyType == "t-notify" then
		if type == '' or type == nil then type = 'info' end
		exports['t-notify']:Alert({style = type, message = msg})
	elseif Config.NotifyType == "feedm" then
		if type == '' or type == nil then type = 'primary' end
		TriggerEvent("FeedM:showNotification", msg, 2500, type)
	elseif Config.NotifyType == "mythic_notify" then
		if type == '' or type == nil then type = 'inform' end
		exports['mythic_notify']:SendAlert(type, msg, 2500)
	else
		ESX.ShowNotification(msg)
	end
end)

RegisterNetEvent('bixbi_hospital:loading')
AddEventHandler("bixbi_hospital:loading", function(time, text)
	
	if Config.LoadingType == "pogress" then
		exports['pogressBar']:drawBar(time, text)
	elseif Config.LoadingType == "mythic" then
		exports['mythic_progbar']:Progress({
			name = string.gsub(text, "%s+", ""),
			duration = time,
			label = text,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			},
		}, function()
		end)
	else
		-- Do nothing.
	end
end)