Config = {}

Config.MaxTime = 600 -- 10 Minutes (600 seconds)

Config.Locations = {
	P = {
		label = "Pillbox Hospital",
		incoords = {354.4615, -589.2791, 43.29895},
		outcoords = {318.5802, -579.244, 43.3158}
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
	else
		ESX.ShowNotification(msg)
	end
end)