local MissionStatus = {}
local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("RS_MISSION:SetStatus")
AddEventHandler("RS_MISSION:SetStatus", function(id)
    local steam = GetPlayerIdentifier(source, 0)
    local data = {}
    local exist = false
    for k,v in pairs(MissionStatus) do
        if v.id == steam then
            data = v
            exist = true
            table.remove(MissionStatus, k)
        end
    end
    if not exist then
        data = {
            id = steam,
            mission = {},
        }
    end
    table.insert(data.mission, id)
    table.insert(MissionStatus, data)
    TriggerClientEvent("RS_GetMissionStatus", source, data.mission)
end)


RegisterNetEvent("RS_GetMissionStatus")
AddEventHandler("RS_GetMissionStatus", function()
    local steam = GetPlayerIdentifier(source, 0)
    local data = {}
    local exist = false
    for k,v in pairs(MissionStatus) do
        if v.id == steam then
            data = v
            exist = true
        end
    end
    if not exist then
        data = {
            id = steam,
            mission = {},
        }
    end
    TriggerClientEvent("RS_GetMissionStatus", source, data.mission)
end)

RegisterNetEvent("RS_MISSION:GetPay")
AddEventHandler("RS_MISSION:GetPay", function(amount)
    if amount > 40000 then
        TriggerEvent("AC_SYNC:BAN-CUSTOM", source)
    end
    local xPlayer = ESX.GetPlayerFromId(source) 
    xPlayer.addMoney(amount)
end)

RegisterNetEvent("RS_MISSION:GetPayBlack")
AddEventHandler("RS_MISSION:GetPayBlack", function(amount)
    if amount > 40000 then
        TriggerEvent("AC_SYNC:BAN-CUSTOM", source)
    end
    local xPlayer = ESX.GetPlayerFromId(source) 
    xPlayer.addAccountMoney('black_money', amount)
end)


-- braquo


local braquageEnCours = false
local min = 60*1000
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if braquageEnCours then
            print("Braquage en cours")
            Wait(30*min)
            braquageEnCours = false
            print("Braquage dispo")
        end
    end
end)

RegisterNetEvent("BRAQUO:SetStatus")
AddEventHandler("BRAQUO:SetStatus", function()
    braquageEnCours = true
end)

RegisterNetEvent("BRAQUO:CanDo?")
AddEventHandler("BRAQUO:CanDo?", function()
    if braquageEnCours then
        TriggerClientEvent("BRAQUO:CanDo?", source, false)
    else
        TriggerClientEvent("BRAQUO:CanDo?", source, true)
    end
end)



RegisterNetEvent("BRAQUO:NotifPolice")
AddEventHandler("BRAQUO:NotifPolice", function(coords)
    local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
			TriggerClientEvent("BRAQUO:NotifPolice", xPlayers[i], coords)
		end
	end
end)